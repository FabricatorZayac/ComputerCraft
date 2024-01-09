local barrel
local storage = {}

for _, i in ipairs(peripheral.getNames()) do
  if string.find(i, "barrel") then
    barrel = peripheral.wrap(i)
  elseif string.find(i, "chest") then
    table.insert(storage, peripheral.wrap(i))
  end
end
