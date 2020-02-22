#pragma once
#ifndef __pongasoft__ProjectConstants__
#define __pongasoft__ProjectConstants__

#include "Constants.h"

const int MAX_ARRAY_SIZE = 256;
const int MAX_DISPLAY_H = 118; // value in fPropArray will be [0, MAX_DISPLAY_H] for "normal values"
const int SOFT_CLIPPING_OFFSET = 256; // value in fPropArray will be offset by SOFT_CLIPPING_OFFSET when soft clipping
const int HARD_CLIPPING_VALUE = 500; // value in fPropArray when clipping
const int MAX_PROP_UPDATES_PER_BATCH = 32;

const TJBox_Float64 MIN_VOLUME = -60; // -60dB
//const TJBox_AudioSample MIN_AUDIO_SAMPLE = std::pow(10, MIN_VOLUME / 20.0);
const TJBox_AudioSample MIN_AUDIO_SAMPLE = 0.001;

const int MIN_ZOOM_IN_SECONDS = 30;
const int MAX_ZOOM_IN_SECONDS = 5;

enum EMaxLevelWindowState
{
  kStateOk = 0,
  kStateSoftClipping = 1,
  kStateHardClipping = 2
};

#endif /* define(__pongasoft__ProjectConstants__) */
