format_version = "1.0"

local maxResolution = 256

local mainLCDCustomDisplayValues = {
  "/custom_properties/prop_soft_clipping_level_display",
  "/custom_properties/prop_lcd_hud_alpha",
  "/custom_properties/prop_max_level_window_1_size",
  "/custom_properties/prop_max_level_window_2_size",
  "/custom_properties/prop_max_level_window_3_size",
  "/custom_properties/prop_array_start",
  "/custom_properties/prop_array_size",
}

for i = 1, maxResolution do
  mainLCDCustomDisplayValues[#mainLCDCustomDisplayValues + 1] = "/custom_properties/prop_array_" .. i
end

local frontWidgets = {
  -- device name / tape
  jbox.device_name {
    graphics = {
      node = "TapeFront",
    },
  },

  jbox.sequence_fader{
    graphics={
      node = "OnOffBypass",
    },
    value="/custom_properties/builtin_onoffbypass",
  },

  jbox.analog_knob {
    graphics = {
      node = "ZoomLevel",
    },
    value="/custom_properties/prop_zoom_level",
  },

  jbox.analog_knob {
    graphics = {
      node = "SoftClippingLevel",
    },
    value="/custom_properties/prop_soft_clipping_level",
  },

  jbox.analog_knob {
    graphics = {
      node = "LCDHUDAlpha",
    },
    value="/custom_properties/prop_lcd_hud_alpha",
  },

  jbox.custom_display{
    graphics = {
      node = "Main_LCD",
    },
    background = jbox.image{path = "Main_LCD_Background"},
    display_width_pixels = math.floor(1280 / 5),
    display_height_pixels = math.floor(590 / 5),
    draw_function = "MainLCDDraw",
    values = mainLCDCustomDisplayValues
  },

  jbox.analog_knob {
    graphics = {
      node = "Volume1",
    },
    value="/custom_properties/prop_volume_1",
  },

  jbox.analog_knob {
    graphics = {
      node = "Volume2",
    },
    value="/custom_properties/prop_volume_2",
  },

  jbox.value_display{
    graphics = {
      node = "TotalVolume",
    },
    value = "/custom_properties/prop_total_volume",
    read_only = true,
    text_color = { 255, 255, 255 },
    text_style = "Bold LCD font",
  },

}

local foldedFrontWidgets = {
  -- device name / tape
  jbox.device_name {
    graphics = {
      node = "TapeFoldedFront",
    },
  },

  jbox.sequence_fader{
    graphics={
      node = "OnOffBypass",
    },
    value="/custom_properties/builtin_onoffbypass",
  },

  jbox.analog_knob {
    graphics = {
      node = "Volume1",
    },
    value="/custom_properties/prop_volume_1",
  },

  jbox.analog_knob {
    graphics = {
      node = "Volume2",
    },
    value="/custom_properties/prop_volume_2",
  },

  jbox.value_display{
    graphics = {
      node = "TotalVolume",
    },
    value = "/custom_properties/prop_total_volume",
    read_only = true,
    text_color = { 255, 255, 255 },
    text_style = "Bold LCD font",
  },
}

for i = 1, 3 do
  local maxLevelWindowValueCustomDisplay = jbox.custom_display {
    graphics = {
      node = "MaxLevelWindow" .. i .. "Value",
    },
    background = jbox.image{path = "Display_23_1frames_Background"},
    display_width_pixels = 49,
    display_height_pixels = 19,
    draw_function = "MaxLevelWindowValueDraw",
    values = {
      "/custom_properties/prop_max_level_window_" .. i .. "_value",
      "/custom_properties/prop_max_level_window_" .. i .. "_state",
      "/custom_properties/prop_max_level_window_" .. i .. "_size"
    }
  }

  frontWidgets[#frontWidgets + 1] = maxLevelWindowValueCustomDisplay
  foldedFrontWidgets[#foldedFrontWidgets + 1] = maxLevelWindowValueCustomDisplay

  frontWidgets[#frontWidgets + 1] = jbox.custom_display {
    graphics = {
      node = "MaxLevelWindow" .. i .. "SizeAsText",
    },
    background = jbox.image{path = "Knob_text_background"},
    display_width_pixels = 50,
    display_height_pixels = 16,
    draw_function = "MaxLevelWindow" .. i .. "SizeAsTextDraw",
    values = {
      "/custom_properties/prop_zoom_level",
      "/custom_properties/prop_max_level_window_" .. i .. "_size"
    }
  }

  frontWidgets[#frontWidgets + 1] = jbox.analog_knob {
    graphics = {
      node = "MaxLevelWindow" .. i .. "Size",
    },
    value="/custom_properties/prop_max_level_window_" .. i .. "_size",
  }

end

front = jbox.panel {
  graphics = {
    node = "Bg",
  },
  widgets = frontWidgets
}

back = jbox.panel {
  graphics = {
    node = "Bg"
  },
  widgets = {

    -- device name / tape
    jbox.device_name {
      graphics = {
        node = "TapeBack",
      },
    },

    -- placeholder
    jbox.placeholder {
      graphics = {
        node = "Placeholder",
      },
    },

    -- audio output
    jbox.audio_output_socket {
      graphics = {
        node = "audioOutputStereoPairLeft",
      },
      socket = "/audio_outputs/audioOutputLeft",
    },
    jbox.audio_output_socket {
      graphics = {
        node = "audioOutputStereoPairRight",
      },
      socket = "/audio_outputs/audioOutputRight",
    },

    -- audio input
    jbox.audio_input_socket {
      graphics = {
        node = "audioInputStereoPairLeft",
      },
      socket = "/audio_inputs/audioInputLeft",
    },
    jbox.audio_input_socket {
      graphics = {
        node = "audioInputStereoPairRight",
      },
      socket = "/audio_inputs/audioInputRight",
    },
  },
}


folded_front = jbox.panel {
  graphics = {
    node = "Bg",
  },
  widgets = foldedFrontWidgets
}

folded_back = jbox.panel {
  graphics = {
    node = "Bg",
  },
  cable_origin = {
    node = "CableOrigin",
  },
  widgets = {
    -- device name / tape
    jbox.device_name {
      graphics = {
        node = "TapeFoldedBack",
      },
    },
  },
}
