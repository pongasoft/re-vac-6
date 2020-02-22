//
// Created by Yan Pujante on 5/23/15.
//

#ifndef __pongasoft__BlankDeviceState_h__
#define __pongasoft__BlankDeviceState_h__


#include "JBoxPropertyManager.h"
#include "AudioSocket.h"
#include "Motherboard.h"
#include "ProjectConstants.h"
#include "CircularBuffer.h"

int const NO_UPDATE = -1;

template<int size>
class PendingUpdates
{
public:
  PendingUpdates(Int32JBoxProperty **iPropArray) : fPendingCount(0), fPropArray(iPropArray)
  {
    for(int i = 0; i < size; ++i)
    {
      fPendingUpdates[i] = NO_UPDATE;
    }
  }

  inline bool hasPendingUpdates() const { return fPendingCount > 0; }

  inline TJBox_Int32 getValue(int i) const
  {
    JBOX_ASSERT_RANGE(i, 0, size - 1);

    TJBox_Int32 value = fPendingUpdates[i];

    if(value == NO_UPDATE)
      value = fPropArray[i]->getValue();

    return value;
  }

  inline void setPendingValue(int i, TJBox_Int32 iValue) {
    JBOX_ASSERT_RANGE(i, 0, size - 1);

    if(fPendingUpdates[i] == NO_UPDATE)
    {
      fPendingCount++;
    }
    fPendingUpdates[i] = iValue;
  }

  bool handlePendingUpdates(int maxUpdates)
  {
    bool res = false;

    if(hasPendingUpdates())
    {
      int max = maxUpdates;
      for(int i = 0; i < MAX_ARRAY_SIZE && max > 0; ++i)
      {
        if(storeValueToMotherboard(i))
        {
          res = true;
          max--;
        }
      }
    }

    return res;
  }

private:
  inline bool storeValueToMotherboard(int i)
  {
    JBOX_ASSERT_RANGE(i, 0, size - 1);

    bool res = false;

    TJBox_Int32 value = fPendingUpdates[i];

    if(value != NO_UPDATE)
    {
      res |= fPropArray[i]->storeValueToMotherboardOnUpdate(value);
      fPendingUpdates[i] = NO_UPDATE;
      fPendingCount--;

      JBOX_ASSERT(fPendingCount >= 0);
    }

    return res;
  }

private:
  int fPendingCount;
  TJBox_Int32 fPendingUpdates[size];
  Int32JBoxProperty **fPropArray;
};

class DeviceState
{
public:
  DeviceState(int iSampleRate);
  ~DeviceState() {}

 /*
  * Called to initialize the state on first batch
  */
  void init();

  bool afterMotherboardUpdate(bool motherboardStateChanged,
                              DeviceState const &previousState);

  bool handlePendingUpdates() { return fPendingUpdates.handlePendingUpdates(MAX_PROP_UPDATES_PER_BATCH); }

  void update(const DeviceState &rhs);

  inline int getWindowSize() const { return fWindowSize; }
  inline TJBox_AudioSample getSoftClippingLevel() const { return fMotherboard.fPropSoftClippingLevel.getValue(); }
  inline TJBox_Float32 getVolume1() const { return fVolume1.getVolume(); }
  inline TJBox_Float32 getVolume2() const { return fVolume2.getVolume(); }
  inline int getSampleRate() const { return fSampleRate; }

  inline TJBox_Float64 toDisplayVolume(TJBox_AudioSample audioSample) const {
    return -((toVolume(audioSample) / MIN_VOLUME) - 1.0);
  }

  TJBox_Int32 toDisplayValue(TJBox_AudioSample audioSample) const;
  EMaxLevelWindowState toMaxLevelWindowState(TJBox_AudioSample audioSample) const;

  /**
   * If the same value is constantly being displayed there is no point in updating the display...
   */
  inline bool shouldUpdateArrayStart(TJBox_Int32 iCVIn1Display)
  {
    if(iCVIn1Display == fLastCVIn1Display)
    {
      if(fCVIn1DisplayUniqueCount > MAX_ARRAY_SIZE)
        return false;

      fCVIn1DisplayUniqueCount++;
    }
    else
    {
      fCVIn1DisplayUniqueCount = 0;
    }

    fLastCVIn1Display = iCVIn1Display;


    return true;
  }

public:
  Motherboard fMotherboard;

  // one sample per frame
  CircularBuffer<TJBox_AudioSample> fMaxSampleValuePerFrame;

  int fNextWindowUpdate; // in frames

  PendingUpdates<MAX_ARRAY_SIZE> fPendingUpdates;

private:
  void recomputePropArray();

  // used for optimizing display... if the screen stays static there is no need to increment the buffer
  TJBox_Int32 fLastCVIn1Display;
  int fCVIn1DisplayUniqueCount;

  int fSampleRate;
  int fWindowSize;
  VolumeState fVolume1;
  VolumeState fVolume2;
};


#endif //__pongasoft__BlankDeviceState_h__
