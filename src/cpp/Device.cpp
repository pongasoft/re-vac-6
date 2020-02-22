#include "Device.h"

#ifndef  __phdsp__
#include <sstream>
#endif // !__phdsp__

TJBox_AudioSample maxAudioSample(TJBox_AudioSample a, TJBox_AudioSample b);

TJBox_AudioSample maxAudioSample(TJBox_AudioSample a, TJBox_AudioSample b) { return std::max(a, b); };

Device::Device(int iSampleRate): CommonDevice(),
                                 fFirstBatch(true),
                                 fPreviousDeviceState(iSampleRate),
                                 fCurrentDeviceState(iSampleRate)
{
  JBOX_TRACE("Device()");

#ifndef  __phdsp__
  JBOX_TRACE("Local 45 XCode Mode!!!");
  std::stringstream strm;
  strm << this;
  JBOX_TRACE((std::string("New instance => ") + strm.str()).c_str());
#endif // !__phdsp__

  fCurrentDeviceState.fMotherboard.registerForUpdate(fJBoxPropertyManager);
}

Device::~Device()
{
  // nothing to do
  JBOX_TRACE("~Device()");
}

void Device::renderBatch(TJBox_PropertyDiff const iPropertyDiffs[], TJBox_UInt32 iDiffCount)
{
  bool stateChanged = false;

  if(fFirstBatch)
  {
    doInitDevice(iPropertyDiffs, iDiffCount);
    stateChanged = true;
    fFirstBatch = false;
  }
  else
  {
    if(iDiffCount > 0)
    {
      stateChanged |= fJBoxPropertyManager.onUpdate(iPropertyDiffs, iDiffCount);
    }
  }

  stateChanged |= fCurrentDeviceState.afterMotherboardUpdate(stateChanged, fPreviousDeviceState);

  stateChanged |= doRenderBatch(stateChanged);

  if(stateChanged)
    fPreviousDeviceState.update(fCurrentDeviceState);
}

bool Device::doRenderBatch(bool propertyStateChange)
{
  TJBox_AudioSample maxSampleValueInFrame;

  Motherboard &motherboard = fCurrentDeviceState.fMotherboard;

  if(motherboard.fAudioInput.isConnected())
  {
    StereoAudioBuffer buf;

    // bypassed => no output
    if(motherboard.fPropOnOffBypass.isOff())
      buf.clear();
    else
    {
      motherboard.fAudioInput.readAudio(buf);

      // if not bypassed
      if(!motherboard.fPropOnOffBypass.isBypassed())
      {
        buf.adjustGain(fCurrentDeviceState.getVolume1());
        buf.adjustGain(fCurrentDeviceState.getVolume2());
      }
    }

    maxSampleValueInFrame = buf.max();

    // handle silent threshold
    if(maxSampleValueInFrame < kJBox_SilentThreshold)
      maxSampleValueInFrame = 0;

    if(motherboard.fAudioOutput.isConnected() && !buf.isSilent())
      motherboard.fAudioOutput.writeAudio(buf);
  }
  else
  {
    maxSampleValueInFrame = 0;
  }

  fCurrentDeviceState.fMaxSampleValuePerFrame.setAt(0, maxSampleValueInFrame);

  if(fCurrentDeviceState.fNextWindowUpdate == 0)
  {
    TJBox_Int32 arrayStart = motherboard.fPropArrayStart.getValue();
    arrayStart++;
    if(arrayStart >= MAX_ARRAY_SIZE)
      arrayStart = 0;

    TJBox_AudioSample maxSampleValue =
      fCurrentDeviceState.fMaxSampleValuePerFrame.fold(-fCurrentDeviceState.getWindowSize(),
                                                       static_cast<TJBox_AudioSample>(0.0),
                                                       maxAudioSample);

    TJBox_Int32 displayValue = fCurrentDeviceState.toDisplayValue(maxSampleValue);
    if(fCurrentDeviceState.shouldUpdateArrayStart(displayValue))
    {
      if(fCurrentDeviceState.fPendingUpdates.hasPendingUpdates())
        fCurrentDeviceState.fPendingUpdates.setPendingValue(arrayStart, displayValue);
      else
        propertyStateChange |= motherboard.fPropArray[arrayStart]->storeValueToMotherboardOnUpdate(displayValue);
      propertyStateChange |= motherboard.fPropArrayStart.storeValueToMotherboardOnUpdate(arrayStart);
    }

    propertyStateChange |= doHandleMaxLevelWindow(motherboard.fPropMaxLevelWindow1, maxSampleValue);
    propertyStateChange |= doHandleMaxLevelWindow(motherboard.fPropMaxLevelWindow2, maxSampleValue);
    propertyStateChange |= doHandleMaxLevelWindow(motherboard.fPropMaxLevelWindow3, maxSampleValue);


//    JBOX_TRACE((std::string("maxSampleValue=")
//      + std::to_string(maxSampleValue)
//      + ";cvol="
//      + std::to_string(maxSampleValue)
//      + ";vol="
//      + std::to_string(toVolume(maxSampleValue))
//      + ";maxVol="
//      + std::to_string(fCurrentDeviceState.toDisplayValue(maxSampleValue))
//               ).c_str());

    fCurrentDeviceState.fNextWindowUpdate = fCurrentDeviceState.getWindowSize();
  }

  fCurrentDeviceState.fNextWindowUpdate--;

  fCurrentDeviceState.fMaxSampleValuePerFrame.incrementHead();

  fCurrentDeviceState.handlePendingUpdates();

  return propertyStateChange;
}

bool Device::doHandleMaxLevelWindow(MaxLevelWindow &maxLevelWindow, TJBox_AudioSample maxSampleValue)
{
  bool res = false;

  TJBox_Int32 windowSize = maxLevelWindow.fPropMaxLevelWindowSize.getValue();

  if(windowSize > 0)
  {
    TJBox_AudioSample value = maxSampleValue;

    if(windowSize > 1)
    {
      int window1Size = fCurrentDeviceState.getWindowSize() * windowSize;
      value = fCurrentDeviceState.fMaxSampleValuePerFrame.fold(-window1Size,
                                                               static_cast<TJBox_AudioSample>(0.0),
                                                               maxAudioSample);
    }

    res |=
      maxLevelWindow.fPropMaxLevelWindowState.storeValueToMotherboardOnUpdate(fCurrentDeviceState.toMaxLevelWindowState(value));

    if(value > 1.0)
      value = static_cast<TJBox_AudioSample>(1.0 / value);

    res |= maxLevelWindow.fPropMaxLevelWindowValue.storeValueToMotherboardOnUpdate(value);
  }

  return res;
}

void Device::doInitDevice(TJBox_PropertyDiff const iPropertyDiffs[], TJBox_UInt32 iDiffCount)
{
  JBOX_TRACE("doInitDevice()");

  // initialize properties
  fJBoxPropertyManager.initProperties();

  // processes the updates
  fJBoxPropertyManager.onUpdate(iPropertyDiffs, iDiffCount);

  // initialize current device
  fCurrentDeviceState.init();

  // copy to previous state to initialize it too!
  fPreviousDeviceState.update(fCurrentDeviceState);
}
