local enum = require("enum")

local dir = enum {
  "FORWARD",
  "UP",
  "DOWN",
}

local function isLog(direction)
  return ({direction:match {
    FORWARD = turtle.inspect,
    UP = turtle.inspectUp,
    DOWN = turtle.inspectDown,
  }})[2].info.tags["minecraft:logs"]
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
  turtle.turnRight()
  turtle.forward()
  turtle.turnRight()
end

local function mainloop()
  if isLog(dir.FORWARD()) then
    chop()
  end
end

while true do
  mainloop()
end
