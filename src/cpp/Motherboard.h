//
// Created by Yan Pujante on 7/15/15.
//


#ifndef __Motherboard_H_
#define __Motherboard_H_

#include "AudioSocket.h"
#include "ProjectConstants.h"

const TJBox_Tag PROP_ZOOM_LEVEL_TAG = 3002;
const TJBox_Tag PROP_SOFT_CLIPPING_LEVEL_TAG = 3003;
const TJBox_Tag PROP_MAX_LEVEL_WINDOW_1_SIZE = 3004;
const TJBox_Tag PROP_MAX_LEVEL_WINDOW_2_SIZE = 3006;
const TJBox_Tag PROP_MAX_LEVEL_WINDOW_3_SIZE = 3008;
const TJBox_Tag PROP_VOLUME_1 = 3010;
const TJBox_Tag PROP_VOLUME_2 = 3011;

// convert a soft clipping level (0-240) into a soft clipping volume level
// 240 => 0dB (10^0/20 => 1.0 sample value)
// 180 => -6dB => (10^-6/20 => 0.5012 sample value)
// 0 => -24dB => (10^-24/20 => 0.06 sample value)
// => scl = A * x + B in dB => 10 ^ scl/20 in sample
const TJBox_Float64 SOFT_CLIPPING_LEVEL_A = 0.1;
const TJBox_Float64 SOFT_CLIPPING_LEVEL_B = -24;
inline TJBox_AudioSample toSoftClippingLevel(TJBox_Value value)
{
  TJBox_Float64 sclIndB = SOFT_CLIPPING_LEVEL_A * JBox::toJBoxInt32(value) + SOFT_CLIPPING_LEVEL_B;
  return static_cast<TJBox_AudioSample>(std::pow(10, sclIndB / 20));
}

typedef JBoxProperty<TJBox_AudioSample, toSoftClippingLevel, JBox::readOnly<TJBox_AudioSample> > SoftClippingLevelProperty;

class MaxLevelWindow
{
public:
  MaxLevelWindow(char const *iValue,
                 char const *iState,
                 char const *iSize):
    fPropMaxLevelWindowValue(iValue),
    fPropMaxLevelWindowState(iState),
    fPropMaxLevelWindowSize(iSize)
  {
  }

  MaxLevelWindow(MaxLevelWindow const &other) = delete;

  void registerForUpdate(IJBoxPropertyManager &manager, TJBox_Tag iPropMaxLevelWindowSizeTag)
  {
    fPropMaxLevelWindowSize.registerForUpdate(manager, iPropMaxLevelWindowSizeTag);
    fPropMaxLevelWindowState.registerForInit(manager);
    fPropMaxLevelWindowValue.registerForInit(manager);
  }

public:
  Float32JBoxProperty fPropMaxLevelWindowValue;
  Int32JBoxProperty fPropMaxLevelWindowState;
  Int32JBoxProperty fPropMaxLevelWindowSize;
};

class Motherboard
{
public:
  Motherboard();

  void registerForUpdate(IJBoxPropertyManager &manager);
  void update(Motherboard const &rhs);

public:
  StereoOutPair fAudioOutput;
  StereoInPair fAudioInput;

  BuiltInOnOffBypassJBoxProperty fPropOnOffBypass;
  Int32JBoxProperty fPropArrayStart;
  Int32JBoxProperty fPropArraySize;
  Int32JBoxProperty fPropZoomLevel;
  SoftClippingLevelProperty fPropSoftClippingLevel; // in sample value
  Int32JBoxProperty fPropSoftClippingLevelDisplay;

  // Window1
  MaxLevelWindow fPropMaxLevelWindow1;

  // Window2
  MaxLevelWindow fPropMaxLevelWindow2;

  // Window3
  MaxLevelWindow fPropMaxLevelWindow3;

  VolumeCubeJBoxProperty fPropVolume1;
  VolumeCubeJBoxProperty fPropVolume2;
  Float64JBoxProperty fPropTotalVolume;

  Int32JBoxProperty **fPropArray;

private:
  void initPropArray();
};


#endif //__Motherboard_H_
