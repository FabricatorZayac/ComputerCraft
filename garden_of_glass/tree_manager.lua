local enum = require("enum")

local dir = enum {
  "LEFT",
  "RIGHT",
}

local packages = {
  LEFT = peripheral.wrap("left"),
  RIGHT = peripheral.wrap("right"),
}

local function isFull(package)
  local info = package.getItemDetail(8)
  if info == nil then
    return false
  else
    return info.count == 64
  end
end

local function replace(direction)
  direction:match {
    LEFT = function ()
      rs.setBundledOutput("bottom", colors.white)
      rs.setBundledOutput("bottom", 0)
    end,
    RIGHT = function ()
      rs.setBundledOutput("bottom", colors.green)
      rs.setBundledOutput("bottom", 0)
    end,
  }
end

while true do
  for direction, package in pairs(packages) do
    if isFull(package) then
      replace(dir[direction]())
    end
  end
end
