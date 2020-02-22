format_version = "1.0"

-- front
front = {
  Bg = {
    { path = "Panel_Front" },
  },

  TapeFront = {
    offset = { 52, 147 },
    { path = "TapeVert" },
  },

  OnOffBypass = {
    offset = { 180, 15 },
    { path = "Fader_Bypass_3frames", frames = 3 },
  },

  ZoomLevel = {
    offset = { 2685, 270 },
    { path = "Knob_w150_64frames", frames = 64 }
  },

  SoftClippingLevel = {
    offset = { 2685, 50 },
    { path = "Knob_w150_64frames", frames = 64 }
  },

  LCDHUDAlpha = {
    offset = { 2685, 490 },
    { path = "Knob_w150_64frames", frames = 64 }
  },

  -- Window1
  MaxLevelWindow1Size = {
    offset = { 295, 210 },
    { path = "Knob_Max1_64frames", frames = 64 }
  },

  MaxLevelWindow1SizeAsText = {
    offset = { 485, 245 },
    { path = "Knob_text_Max1" }
  },

  MaxLevelWindow1Value = {
    offset = { 825, 240 },
    { path = "Display_23_1frames" }
  },

  -- Window2
  MaxLevelWindow2Size = {
    offset = { 295, 370 },
    { path = "Knob_Max2_64frames", frames = 64 }
  },

  MaxLevelWindow2SizeAsText = {
    offset = { 485, 405 },
    { path = "Knob_text_Max2" }
  },

  MaxLevelWindow2Value = {
    offset = { 825, 400 },
    { path = "Display_23_1frames" }
  },

  -- Window3
  MaxLevelWindow3Size = {
    offset = { 295, 530 },
    { path = "Knob_Max3_64frames", frames = 64 }
  },

  MaxLevelWindow3SizeAsText = {
    offset = { 485, 565 },
    { path = "Knob_text_Max3" }
  },

  MaxLevelWindow3Value = {
    offset = { 825, 560 },
    { path = "Display_23_1frames" }
  },

  -- Volume1
  Volume1 = {
    offset = { 3370, 15 },
    { path = "Knob_Volume_64frames", frames = 64 }
  },

  -- Volume2
  Volume2 = {
    offset = { 3370, 395 },
    { path = "Knob_Volume_64frames", frames = 64 }
  },

  TotalVolume = {
    offset = { 3000, 300 },
    { path = "Knob_text_ValueDisplay" }
  },

  -- Main LCD
  Main_LCD = {
    offset = { 1245, 50 },
    { path = "Main_LCD" },
  },
}

-- back
back = {
  Bg = {
    { path = "Panel_Back" },
  },

  TapeBack = {
    offset = { 1685, 40 },
    { path = "TapeHoriz" },
  },

  Placeholder = {
    offset = { 800, 20 },
    { path = "Placeholder" }
  },

  -- main audio out
  {
    offset = { 2150, 320 },
    audioOutputStereoPairLeft = {
      offset = { 0, 0 },
      { path = "SharedAudioJack", frames = 3 }
    },
    audioOutputStereoPairRight = {
      offset = { 150, 0 },
      { path = "SharedAudioJack", frames = 3 }
    },
  },

  -- main audio in
  {
    offset = { 1420, 320 },
    audioInputStereoPairLeft = {
      offset = { 0, 0 },
      { path = "SharedAudioJack", frames = 3 }
    },
    audioInputStereoPairRight = {
      offset = { 150, 0 },
      { path = "SharedAudioJack", frames = 3 }
    },
  },
}

-- folded front
folded_front = {
  Bg = {
    { path = "Panel_Folded_Front" },
  },

  TapeFoldedFront = {
    offset = { 1685, 40 },
    { path = "TapeHoriz" },
  },

  OnOffBypass = {
    offset = { 180, 15 },
    { path = "Fader_Bypass_3frames", frames = 3 },
  },

  -- Window1
  MaxLevelWindow1Value = {
    offset = { 695, 30 },
    { path = "Display_23_1frames" }
  },

  -- Window2
  MaxLevelWindow2Value = {
    offset = { 1040, 30 },
    { path = "Display_23_1frames" }
  },

  -- Window3
  MaxLevelWindow3Value = {
    offset = { 1385, 30 },
    { path = "Display_23_1frames" }
  },

  -- Volume1
  Volume1 = {
    offset = { 2780, 15 },
    { path = "Knob_Volume_Small_64frames", frames = 64 }
  },

  -- Volume2
  Volume2 = {
    offset = { 2970, 15 },
    { path = "Knob_Volume_Small_64frames", frames = 64 }
  },

  TotalVolume = {
    offset = { 2400, 35 },
    { path = "Knob_text_ValueDisplay" }
  },
}

-- folded back
folded_back = {
  Bg = {
    { path = "Panel_Folded_Back" },
  },
  TapeFoldedBack = {
    offset = { 230, 40 },
    { path = "TapeHoriz" },
  },

  CableOrigin = {
    offset = { 1875, 75 },
  },
}
