local enum = require("enum")

local dir = enum {
  "FORWARD",
  "UP",
  "DOWN",
}

local function dropAll()
  local initialSlot = turtle.getSelectedSlot()
  for i = 1, 16 do
    turtle.select(i)
    turtle.drop()
  end
  turtle.select(initialSlot)
end

local function isLog(direction)
  local blockExists, info = direction:match {
    FORWARD = turtle.inspect,
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
  turtle.forward()
  dropAll()
  turtle.turnRight()
  turtle.forward()
  turtle.turnLeft()
  turtle.suck()
  turtle.turnLeft()
  turtle.turnLeft()
  turtle.forward()
  replant()
  turtle.turnLeft()
  turtle.turnLeft()
  turtle.forward()
  turtle.drop()
  turtle.turnLeft()
  turtle.turnLeft()
  turtle.forward()
end

local function mainloop()
  if isLog(dir.FORWARD()) then
    chop()
  end
end

while true do
  mainloop()
end
