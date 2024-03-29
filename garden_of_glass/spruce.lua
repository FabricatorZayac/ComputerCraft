local enum = require("enum")

local dir = enum {
  "FRONT",
  "UP",
  "DOWN",
}

local function peripheralExists(direction)
  return direction:match {
    FRONT = function ()
      for _, i in ipairs(peripheral.getNames()) do
        if i == "front" then
          return true
        end
      end
      return false
    end,
  }
end

local function dropAll(id, unload)
  for i = 1, 16 do
    turtle.select(i)
    local itemDetail = turtle.getItemDetail()
    if itemDetail and itemDetail.name == id then
      if unload then
        repeat sleep(1) until peripheralExists(dir.FRONT())
      end
      turtle.drop()
    end
  end
end

local function hasInInventory(id)
  for i = 1, 16 do
    turtle.select(i)
    local itemDetail = turtle.getItemDetail()
    if itemDetail and itemDetail.name == id then
      return true;
    end
  end
  return false
end

local function isLog(direction)
  local blockExists, info = direction:match {
    FRONT = turtle.inspect,
    UP = turtle.inspectUp,
    DOWN = turtle.inspectDown,
  }
  if blockExists then
    return info.tags["minecraft:logs"]
  else
    return false
  end
end

local function chopUp()
  while isLog(dir.UP()) do
    turtle.digUp()
    turtle.up()
  end
end

local function chopDown()
  turtle.digUp()
  while isLog(dir.DOWN()) do
    turtle.digDown()
    turtle.down()
  end
end

local function replant()
  turtle.forward()
  turtle.place()
  turtle.turnRight()
  turtle.forward()
  turtle.turnLeft()
  turtle.place()
  turtle.turnRight()
  turtle.back()
  turtle.place()
  turtle.turnLeft()
  turtle.back()
  turtle.place()
end

local function chop()
  turtle.dig()
  turtle.forward()
  chopUp()
  turtle.dig()
  turtle.forward()
  chopDown()
  turtle.turnRight()
  turtle.dig()
  turtle.forward()
  chopUp()
  turtle.turnRight()
  turtle.dig()
  turtle.forward()
  chopDown()
  turtle.forward()
  dropAll("minecraft:spruce_log", true)
  turtle.turnRight()
  turtle.forward()
  dropAll("minecraft:stick")
  turtle.turnLeft()
  turtle.forward()
  turtle.suck()
  turtle.turnLeft()
  turtle.turnLeft()
  turtle.forward()
  replant()
  turtle.turnLeft()
  turtle.turnLeft()
  turtle.forward()
  dropAll("minecraft:spruce_sapling", true)
  turtle.turnRight()
  turtle.turnRight()
  turtle.forward()
end

local function refuel()
  turtle.turnLeft()
  turtle.forward()
  turtle.forward()
  turtle.suck()
  turtle.refuel()
  turtle.back()
  turtle.back()
  turtle.turnRight()
end

local function mainloop()
  if turtle.getFuelLevel() < 500 then
    refuel()
  end
  if isLog(dir.FRONT()) then
    chop()
  end
end

while true do
  mainloop()
end
