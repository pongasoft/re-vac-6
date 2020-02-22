format_version = "1.0"

local maxArraySize = 256
local maxArrayValue = 512

local propArrayStartTag = 2000

local rtOwnerProperties = {}

for i = 1, maxArraySize do
  rtOwnerProperties["prop_array_" .. i] = jbox.number {
    property_tag = propArrayStartTag + i,
    default = 0,
    steps = maxArrayValue,
    ui_name = jbox.ui_text("propertyname prop_array_" .. i),
    ui_type = jbox.ui_linear { min = 0.0, max = 1.0 }
  }
end

rtOwnerProperties["prop_array_start"] = jbox.number {
  property_tag = 3000,
  steps = maxArraySize,
  default = 0,
  ui_name = jbox.ui_text("propertyname prop_array_start"),
  ui_type = jbox.ui_linear { min = 0.0, max = 1.0 }
}

rtOwnerProperties["prop_array_size"] = jbox.number {
  property_tag = 3001,
  steps = maxArraySize + 1,
  default = maxArraySize,
  ui_name = jbox.ui_text("propertyname prop_array_size"),
  ui_type = jbox.ui_linear { min = 0.0, max = 1.0 }
}

-- to display the line for soft clipping
rtOwnerProperties["prop_soft_clipping_level_display"] = jbox.number {
  steps = maxArrayValue,
  default = 0,
  ui_name = jbox.ui_text("propertyname prop_soft_clipping_level_display"),
  ui_type = jbox.ui_linear { min = 0.0, max = 1.0 }
}

-- to display the max level in window 1
rtOwnerProperties["prop_max_level_window_1_value"] = jbox.number {
  default = 0,
  ui_name = jbox.ui_text("propertyname prop_max_level_window_1_value"),
  ui_type = jbox.ui_linear { min = 0.0, max = 1.0 }
}

-- state of prop_max_level_window_1 0 = ok, 1 = soft clipping, 2 = hard clipping
rtOwnerProperties["prop_max_level_window_1_state"] = jbox.number {
  default = 0,
  steps = 3,
  ui_name = jbox.ui_text("propertyname prop_max_level_window_1_state"),
  ui_type = jbox.ui_linear { min = 0.0, max = 1.0 }
}

-- to display the max level in window 2
rtOwnerProperties["prop_max_level_window_2_value"] = jbox.number {
  default = 0,
  ui_name = jbox.ui_text("propertyname prop_max_level_window_2_value"),
  ui_type = jbox.ui_linear { min = 0.0, max = 1.0 }
}

-- state of prop_max_level_window_2 0 = ok, 1 = soft clipping, 2 = hard clipping
rtOwnerProperties["prop_max_level_window_2_state"] = jbox.number {
  default = 0,
  steps = 3,
  ui_name = jbox.ui_text("propertyname prop_max_level_window_2_state"),
  ui_type = jbox.ui_linear { min = 0.0, max = 1.0 }
}

-- to display the max level in window 3
rtOwnerProperties["prop_max_level_window_3_value"] = jbox.number {
  default = 0,
  ui_name = jbox.ui_text("propertyname prop_max_level_window_3_value"),
  ui_type = jbox.ui_linear { min = 0.0, max = 1.0 }
}

-- state of prop_max_level_window_3 0 = ok, 1 = soft clipping, 2 = hard clipping
rtOwnerProperties["prop_max_level_window_3_state"] = jbox.number {
  default = 0,
  steps = 3,
  ui_name = jbox.ui_text("propertyname prop_max_level_window_3_state"),
  ui_type = jbox.ui_linear { min = 0.0, max = 1.0 }
}

-- represents the total volume (accounts for volume 1 and volume 2)
rtOwnerProperties["prop_total_volume"] = jbox.number {
  default = 0.49,
  ui_name = jbox.ui_text("propertyname prop_total_volume"),
  ui_type = jbox.ui_nonlinear{
    -- convert data range 0-1 to dB value using an x^3 curve. 0.49 is 0dB (2 volumes multiplied!).
    data_to_gui = function(data_value)
      local gain = math.pow(data_value / 0.49, 3)
      local ui_value =  20 * math.log10(gain)
      return ui_value
    end,
    -- convert UI dB value to data range 0-1
    gui_to_data = function(gui_value)
      local data_value = math.pow(math.pow(10, gui_value / 20), 1/3) * 0.49
      return data_value
    end,
    units = {
      {min_value=0, unit = {template=jbox.ui_text("ui_type template prop_total_volume"), base=1}, decimals=2},
    },
  }
}

local softClippingLevelA = 0.1
local softClippingLevelB = -24

local documentOwnerProperties = {
  prop_zoom_level = jbox.number {
    property_tag = 3002,
    steps = 126,
    default = 75,
    ui_name = jbox.ui_text("propertyname prop_zoom_level"),
    ui_type = jbox.ui_linear {
      min = 5.0, max = 30.0,
      units = {
        {min_value=0, unit = {template=jbox.ui_text("ui_type template prop_zoom_level"), base=1}, decimals=1},
      },
    }
  },

  prop_soft_clipping_level = jbox.number {
    property_tag = 3003,
    steps = 241,
    default = 180,
    ui_name = jbox.ui_text("propertyname prop_soft_clipping_level"),
    ui_type = jbox.ui_nonlinear{
      -- convert to db
      data_to_gui = function(data_value)
        return (softClippingLevelA * data_value) + softClippingLevelB
      end,
      -- convert from db
      gui_to_data = function(gui_value)
        return (gui_value - softClippingLevelB) / softClippingLevelA
      end,
      units = {
        {min_value=0, unit = {template=jbox.ui_text("ui_type template prop_volume"), base=1}, decimals=2},
      },
    }
  },

  -- window 1
  prop_max_level_window_1_size = jbox.number {
    property_tag = 3004,
    steps = 257,
    default = 10.0,
    ui_name = jbox.ui_text("propertyname prop_max_level_window_1_size"),
    ui_type = jbox.ui_linear { min = 0.0, max = 256.0 }
  },

  -- window 2
  prop_max_level_window_2_size = jbox.number {
    property_tag = 3006,
    steps = 257,
    default = 50.0,
    ui_name = jbox.ui_text("propertyname prop_max_level_window_2_size"),
    ui_type = jbox.ui_linear { min = 0.0, max = 256.0 }
  },

  -- window 3
  prop_max_level_window_3_size = jbox.number {
    property_tag = 3008,
    steps = 257,
    default = 256.0,
    ui_name = jbox.ui_text("propertyname prop_max_level_window_3_size"),
    ui_type = jbox.ui_linear { min = 0.0, max = 256.0 }
  },

  -- 0 means off (no hud)
  prop_lcd_hud_alpha = jbox.number {
    steps = 256,
    default = 200.0,
    ui_name = jbox.ui_text("propertyname prop_lcd_hud_alpha"),
    ui_type = jbox.ui_percent()
  },

}

for i = 1, 2 do
  -- number, nonlinear decibel:
  documentOwnerProperties["prop_volume_" .. i] = jbox.number{
    property_tag = 3009 + i,
    default = 0.7,
    ui_name = jbox.ui_text("propertyname prop_volume_" .. i),
    ui_type = jbox.ui_nonlinear{
      -- convert data range 0-1 to dB value using an x^3 curve. Data value 0.7 is 0 dB.
      data_to_gui = function(data_value)
        local gain = math.pow(data_value / 0.7, 3)
        local ui_value =  20 * math.log10(gain)
        return ui_value
      end,
      -- convert UI dB value to data range 0-1
      gui_to_data = function(gui_value)
        local data_value = math.pow(math.pow(10, gui_value / 20), 1/3) * 0.7
        return data_value
      end,
      units = {
        {min_value=0, unit = {template=jbox.ui_text("ui_type template prop_volume"), base=1}, decimals=2},
      },
    }
  }
end

--[[
Custom properties
--]]
custom_properties = jbox.property_set {
  document_owner = {
    properties = documentOwnerProperties
  },

  rtc_owner = {
    properties = {
      instance = jbox.native_object{ },
    }
  },

  rt_owner = {
    properties = rtOwnerProperties
  }
}

--[[
Inputs/Outputs
--]]

audio_outputs = {
  audioOutputLeft = jbox.audio_output {
    ui_name = jbox.ui_text("audio output main left")
  },
  audioOutputRight = jbox.audio_output {
    ui_name = jbox.ui_text("audio output main right")
  }
}

audio_inputs = {
  audioInputLeft = jbox.audio_input {
    ui_name = jbox.ui_text("audio input main left")
  },
  audioInputRight = jbox.audio_input {
    ui_name = jbox.ui_text("audio input main right")
  }
}

-- defines routing pairs for stereo (Reason will wire left and right automatically)

jbox.add_stereo_audio_routing_pair {
  left = "/audio_outputs/audioOutputLeft",
  right = "/audio_outputs/audioOutputRight"
}

jbox.add_stereo_audio_routing_pair {
  left = "/audio_inputs/audioInputLeft",
  right = "/audio_inputs/audioInputRight"
}

-- The 45 should be routed as a stereo instrument
jbox.add_stereo_effect_routing_hint{
  type = "true_stereo",
  left_input = "/audio_inputs/audioInputLeft",
  right_input = "/audio_inputs/audioInputRight",
  left_output = "/audio_outputs/audioOutputLeft",
  right_output = "/audio_outputs/audioOutputRight"
}

-- Sockets on the back panel of the 45 that the host can auto-route to
jbox.add_stereo_audio_routing_target{
  signal_type = "normal",
  left = "/audio_outputs/audioOutputLeft",
  right = "/audio_outputs/audioOutputRight",
  auto_route_enable = true
}

-- handle no license case
jbox.set_effect_auto_bypass_routing {
  {
    "/audio_inputs/audioInputLeft",
    "/audio_outputs/audioOutputLeft"
  },
  {
    "/audio_inputs/audioInputRight",
    "/audio_outputs/audioOutputRight"
  }
}


-- allow for automation
midi_implementation_chart = {
  midi_cc_chart = {
    [12] = "/custom_properties/prop_volume_1",
    [13] = "/custom_properties/prop_volume_2",
  }
}

remote_implementation_chart = {
  ["/custom_properties/prop_volume_1"] = {
    internal_name = "Volume 1",
    short_ui_name = jbox.ui_text("short property name remote prop_volume_1"),
    shortest_ui_name = jbox.ui_text("shortest property name remote prop_volume_1")
  },
  ["/custom_properties/prop_volume_2"] = {
    internal_name = "Volume 2",
    short_ui_name = jbox.ui_text("short property name remote prop_volume_2"),
    shortest_ui_name = jbox.ui_text("shortest property name remote prop_volume_2")
  },
}
