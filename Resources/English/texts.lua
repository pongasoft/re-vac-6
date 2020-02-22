format_version = "1.0"

-- Note that remote name text lenghts are:
--		internal_name = max 64 chars,
--		short_name = max 8 chars,
--		shortest_ui_name = max 4 chars

local maxResolution = 256

-- english
texts = {
	["audio output main left"] = "Main Out Left",
	["audio output main right"] = "Main Out Right",
  ["audio input main left"] = "Main In Left",
  ["audio input main right"] = "Main In Right",
  ["propertyname prop_array_start"] = "Array Start",
  ["propertyname prop_array_size"] = "Array Size",
	["propertyname prop_zoom_level"] = "Zoom Level",
  ["ui_type template prop_zoom_level"] = "^0 s",
  ["propertyname prop_soft_clipping_level"] = "Soft Clipping Level",
  ["propertyname prop_soft_clipping_level_display"] = "Soft Clipping Level",
  ["propertyname prop_lcd_hud_alpha"] = "Opacity",

  ["propertyname prop_max_level_window_1_value"] = "Peak [1]",
  ["propertyname prop_max_level_window_1_state"] = "Peak State [1]",
  ["propertyname prop_max_level_window_1_size"] = "Peak Window Size [1]",

  ["propertyname prop_max_level_window_2_value"] = "Peak [2]",
  ["propertyname prop_max_level_window_2_state"] = "Peak State [2]",
  ["propertyname prop_max_level_window_2_size"] = "Peak Window Size [2]",

  ["propertyname prop_max_level_window_3_value"] = "Peak [3]",
  ["propertyname prop_max_level_window_3_state"] = "Peak State [3]",
  ["propertyname prop_max_level_window_3_size"] = "Peak Window Size [3]",

  ["propertyname prop_volume_1"] = "Volume [1]",
  ["propertyname prop_volume_2"] = "Volume [2]",
  ["propertyname prop_total_volume"] = "Total Volume",
  ["ui_type template prop_volume"] = "^0 dB",
  ["ui_type template prop_total_volume"] = "^0dB",

  ["short property name remote prop_volume_1"] = "Vol1",
  ["shortest property name remote prop_volume_1"] = "Vol1",

  ["short property name remote prop_volume_2"] = "Vol2",
  ["shortest property name remote prop_volume_2"] = "Vol2",
}

for i = 1, maxResolution do
  texts["propertyname prop_array_" .. i] = "Array [" .. i .. "]"
end
