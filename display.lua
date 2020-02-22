format_version = "1.0"

local maxArraySize = 256
local softClippingOffset = 256
local hardClippingValue = 500

-------------------------------------------------

local mainLCDWidth = 256
local mainLCDHeight = 118

local colorMainLCDLine = { r = 0, g = 255, b = 0 }
local colorMainLCDHardClipping = { r = 255, g = 0, b = 0 }
local colorMainLCDSoftClipping = { r = 248, g = 122, b = 0 }

local maxLevelWindow1 = {
  lineColor = { r = 255, g = 255, b = 0 },
  lineTop = mainLCDHeight - 6,
  textColor = { r = 0, g = 0, b = 0},
}

local maxLevelWindow2 = {
  lineColor = { r = 105, g = 122, b = 244 },
  lineTop = mainLCDHeight - 4,
  textColor = { r = 255, g = 255, b = 255},
}

local maxLevelWindow3 = {
  lineColor = { r = 230, g = 9, b = 196 },
  lineTop = mainLCDHeight - 2,
  textColor = { r = 255, g = 255, b = 255},
}

local zoomLevel = {
  lineColor = { r = 123, g = 123, b = 123 },
  textColor = { r = 255, g = 255, b = 255},
}


local propMainLCDSoftClippingLevelDisplay = 1
local propMainLCDHUDAlpha = 2
local propMainLCDMaxLevelWindow1Size = 3
local propMainLCDMaxLevelWindow2Size = 4
local propMainLCDMaxLevelWindow3Size = 5
local propMainLCDArrayStartIdx = 6
local propMainLCDArraySizeIdx = 7
local propMainLCDArrayIdx = 8

local propMaxLevelWindowValue = 1
local propMaxLevelWindowState = 2
local propMaxLevelWindowSize = 3

local propMaxLevelWindowSizeAsTextZoomLevel = 1
local propMaxLevelWindowSizeAsTextSize = 2

local maxLevelStateOk = 0
local maxLevelStateSoftClipping = 1
local maxLevelStateHardClipping = 2

local maxLevelColors = {
  [maxLevelStateOk] = colorMainLCDLine,
  [maxLevelStateSoftClipping] = colorMainLCDSoftClipping,
  [maxLevelStateHardClipping] = colorMainLCDHardClipping
}

-------------------------------------------------
--- MainLCD
-------------------------------------------------
function drawMaxLevelWindow(propSize, window, lcdHUDAlpha)
  if propSize > 0 then

    local left = mainLCDWidth - propSize
    local color = {r = window.lineColor.r, g = window.lineColor.g, b = window.lineColor.b, a = lcdHUDAlpha }

    -- draw the line
    jbox_display.draw_rect({left = left, top = window.lineTop, right = mainLCDWidth, bottom = window.lineTop + 2 },
                           color)
  end
end

MainLCDDraw = function(props, di, dr)
  -- jbox.trace("draw")

  local idx = props[propMainLCDArrayStartIdx]
  local size = props[propMainLCDArraySizeIdx]
  local left = 0

  local volume

  while size > 0 do

    -- we increase first as the latest entry should be at the right edge of the display => latest value to
    -- be displayed
    idx = idx + 1
    if idx >= maxArraySize then
      idx = 0
    end

    volume = props[propMainLCDArrayIdx + idx]

    local lineColor = colorMainLCDLine
    if(volume == hardClippingValue) then
      lineColor = colorMainLCDHardClipping
    else
      if volume >= softClippingOffset then -- -6dB
        lineColor = colorMainLCDSoftClipping
        volume = volume - softClippingOffset
      end
    end

    local top = mainLCDHeight - volume
    jbox_display.draw_rect({left = left, top = top, right = left + 1, bottom = mainLCDHeight }, lineColor)

    left = left + 1
    size = size - 1
  end

  local softClippingLine = mainLCDHeight - props[propMainLCDSoftClippingLevelDisplay]
  jbox_display.draw_rect({left = 0, top = softClippingLine, right = mainLCDWidth, bottom = softClippingLine + 1 },
                         {r = 200, g = 200, b = 200, a = 123})

  local lcdHUDAlpha = props[propMainLCDHUDAlpha]

  if lcdHUDAlpha > 0 then
    drawMaxLevelWindow(props[propMainLCDMaxLevelWindow1Size], maxLevelWindow1, lcdHUDAlpha)
    drawMaxLevelWindow(props[propMainLCDMaxLevelWindow2Size], maxLevelWindow2, lcdHUDAlpha)
    drawMaxLevelWindow(props[propMainLCDMaxLevelWindow3Size], maxLevelWindow3, lcdHUDAlpha)
  end

end

-------------------------------------------------
--- MaxLevelWindowValueDraw
-------------------------------------------------
MaxLevelWindowValueDraw = function(props, di, dr)
  if props[propMaxLevelWindowSize] > 0 then
    local value = props[propMaxLevelWindowValue]
    local state = props[propMaxLevelWindowState]

    -- jbox.trace("draw " .. tostring(value))

    local textValue = "---.--"

    if value > 0 then
      if state == maxLevelStateHardClipping then
        value = 1.0 / value
      end
      textValue = string.format("%+.2f", 20 * math.log10(value))
    end

    jbox_display.draw_text({left = 0, top = 0, right = 49, bottom = 19},
      "center",
      textValue,
      "Bold LCD font",
      maxLevelColors[state]
    )
  end
end

-------------------------------------------------
--- MaxLevelWindowXSizeAsTextDraw
-------------------------------------------------
function drawMaxLevelWindowSizeAsText(zoomLevel, propSize, window)

  -- we draw the background no matter what
  jbox_display.draw_rect({left = 0, top = 0, right = 50, bottom = 16}, window.lineColor)

  -- we write the text
  if propSize > 0 then
    local windowSizeInSeconds = 0.2 * zoomLevel + 5.0

    -- draw the text value
    jbox_display.draw_text({left = 0, top = 0, right = 50, bottom = 16},
      "center",
      string.format("%.3fs", windowSizeInSeconds * propSize / maxArraySize),
      "Bold LCD font",
      window.textColor
    )
  end
end

MaxLevelWindow1SizeAsTextDraw = function(props, di, dr)
  drawMaxLevelWindowSizeAsText(props[propMaxLevelWindowSizeAsTextZoomLevel],
                               props[propMaxLevelWindowSizeAsTextSize],
                               maxLevelWindow1)
end

MaxLevelWindow2SizeAsTextDraw = function(props, di, dr)
  drawMaxLevelWindowSizeAsText(props[propMaxLevelWindowSizeAsTextZoomLevel],
                               props[propMaxLevelWindowSizeAsTextSize],
                               maxLevelWindow2)
end

MaxLevelWindow3SizeAsTextDraw = function(props, di, dr)
  drawMaxLevelWindowSizeAsText(props[propMaxLevelWindowSizeAsTextZoomLevel],
                               props[propMaxLevelWindowSizeAsTextSize],
                               maxLevelWindow3)
end
