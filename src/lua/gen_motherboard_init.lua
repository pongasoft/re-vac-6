local maxArraySize = 256

local mainLCDCustomDisplayValues = {}

local output = {}

for i = 1, maxArraySize do
  output[#output + 1] = string.format("fPropArray[%d] = new Int32JBoxProperty(\"/custom_properties/prop_array_%d\");", i - 1, i)
end

for k, output in pairs(output) do
  print(output)
end