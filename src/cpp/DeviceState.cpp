//
// Created by Yan Pujante on 5/23/15.
//

#include "DeviceState.h"

int computeWindowSize(int iSampleRate, TJBox_Int32 zoomLevel);

int computeWindowSize(int iSampleRate, TJBox_Int32 zoomLevel)
{
// convert ZoomLevel 0-125 into a window size in seconds (5s - 30s)
// => windowSizeInSeconds = 0.2 * value + 5 // (0.2 = (30-5)/125)
  auto windowSizeInSeconds = 0.2 * zoomLevel + 5.0;

  return static_cast<int>(ceil(windowSizeInSeconds * iSampleRate / MAX_ARRAY_SIZE / kBatchSize));
}

DeviceState::DeviceState(int iSampleRate) :
  fMaxSampleValuePerFrame(iSampleRate * MIN_ZOOM_IN_SECONDS),
  fNextWindowUpdate(0),
  fPendingUpdates(fMotherboard.fPropArray),
  fLastCVIn1Display(0),
  fCVIn1DisplayUniqueCount(0),
  fSampleRate(iSampleRate),
  fVolume1(1.0, false),
  fVolume2(1.0, false)
{
}

void DeviceState::init()
{
  fMaxSampleValuePerFrame.init(0);

  fWindowSize = computeWindowSize(fSampleRate, fMotherboard.fPropZoomLevel.getValue());

  // since the device starts empty (fMaxSampleValuePerFrame) there is no point in recovering undo values
  fMotherboard.fPropArrayStart.initMotherboard(0);
  fMotherboard.fPropArraySize.initMotherboard(MAX_ARRAY_SIZE);

  for(int i = 0; i < MAX_ARRAY_SIZE; i++)
  {
    fMotherboard.fPropArray[i]->initMotherboard(0);
  }

  // since this property is derived from softClippingLevel we initialize it this way
  fMotherboard.fPropSoftClippingLevelDisplay.initMotherboard(static_cast<TJBox_Int32 >(toDisplayVolume(getSoftClippingLevel()) * MAX_DISPLAY_H));
}

bool DeviceState::afterMotherboardUpdate(bool motherboardStateChanged, DeviceState const &previousState)
{
  bool windowSizeChanged = false;

  // recompute window size when it changes
  if(fMotherboard.fPropZoomLevel.getValue() != previousState.fMotherboard.fPropZoomLevel.getValue())
  {
    windowSizeChanged = true;
    fWindowSize = computeWindowSize(getSampleRate(), fMotherboard.fPropZoomLevel.getValue());
  }

  if(windowSizeChanged ||
    getSoftClippingLevel() != previousState.getSoftClippingLevel() ||
    getSampleRate() != previousState.getSampleRate())
  {
    fNextWindowUpdate = fWindowSize;

    recomputePropArray();

    fMotherboard.fPropSoftClippingLevelDisplay.storeValueToMotherboardOnUpdate(static_cast<TJBox_Int32 >(toDisplayVolume(getSoftClippingLevel()) * MAX_DISPLAY_H));

    motherboardStateChanged = true;
  }

  bool gainChange = false;

  gainChange |= fVolume1.adjustVolume(fMotherboard.fPropVolume1.getValue());
  gainChange |= fVolume2.adjustVolume(fMotherboard.fPropVolume2.getValue());

  if(gainChange)
  {
    TJBox_Float64 totalVolume = fVolume1.getVolume() * fVolume2.getVolume();
    // we multiply twice by 0.7 because there are 2 volumes that gets multiplied! => can be greater than 1!
    totalVolume = std::pow(totalVolume, 1.0/3) * 0.7 * 0.7;
    if(totalVolume > 1.0)
      totalVolume = 1.0;
    fMotherboard.fPropTotalVolume.storeValueToMotherboardOnUpdate(totalVolume);
  }

  motherboardStateChanged |= gainChange;

  return motherboardStateChanged;
}

void DeviceState::update(const DeviceState &rhs)
{
  fMotherboard.update(rhs.fMotherboard);
  fVolume1.update(rhs.fVolume1);
  fVolume2.update(rhs.fVolume2);
  fWindowSize = rhs.fWindowSize;
}

void DeviceState::recomputePropArray()
{
  JBOX_ASSERT_MESSAGE(fWindowSize * MAX_ARRAY_SIZE <= fMaxSampleValuePerFrame.getSize(), "window size too big");

  int index = -(fWindowSize * MAX_ARRAY_SIZE);

//  JBOX_TRACE((std::string("++++windowSize=") + std::to_string(windowSize)
//    + std::string(";index=") + std::to_string(index)
//    + std::string(";zoomLevel=") + std::to_string(getZoomLevel())
//    + std::string(";softClippingLevel=") + std::to_string(getSoftClippingLevel())
//             ).c_str());

  for(int i = 0; i < MAX_ARRAY_SIZE; i++)
  {
    TJBox_AudioSample maxSampleValue = 0;
    for(int j = 0; j < fWindowSize; ++j, ++index)
    {
      maxSampleValue = std::max(maxSampleValue, fMaxSampleValuePerFrame.getAt(index));
    }
    fPendingUpdates.setPendingValue(i, toDisplayValue(maxSampleValue));
  }
  fMotherboard.fPropArrayStart.storeValueToMotherboardOnUpdate(MAX_ARRAY_SIZE - 1);

  fCVIn1DisplayUniqueCount = 0;
  fLastCVIn1Display = fPendingUpdates.getValue(MAX_ARRAY_SIZE - 1);
}

TJBox_Int32 DeviceState::toDisplayValue(TJBox_AudioSample audioSample) const
{
  if(audioSample < kJBox_SilentThreshold)
    return 0;

  if(audioSample <= MIN_AUDIO_SAMPLE)
    return 1; // a single pixel for -60dB to silent

  if(audioSample > 1.0)
    return HARD_CLIPPING_VALUE;

  TJBox_Float64 displayVolume = toDisplayVolume(audioSample);

  TJBox_Int32 displayValue = static_cast<TJBox_Int32>(ceil(displayVolume * MAX_DISPLAY_H));

  if(audioSample > getSoftClippingLevel())
    displayValue += SOFT_CLIPPING_OFFSET;

  return displayValue;
}

EMaxLevelWindowState DeviceState::toMaxLevelWindowState(TJBox_AudioSample audioSample) const
{
  if(audioSample <= MIN_AUDIO_SAMPLE)
    return kStateOk;

  if(audioSample > 1.0)
    return kStateHardClipping;

  if(audioSample > getSoftClippingLevel())
    return kStateSoftClipping;

  return kStateOk;
}
