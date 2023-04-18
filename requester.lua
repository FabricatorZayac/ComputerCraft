local initial_pos = {}
initial_pos.x, initial_pos.z, initial_pos.y = gps.locate(5)
local loader_pos = {x = 268, z = 450, y = 60}

local items = {
    ingotIron = 1, nil, nil,
    nil,         nil, nil,
    nil,         nil, nil,
}

local function locate()
  local x, z, y = gps.locate(5)
  return {x = x, y = y, z = z}
end

local function dock()
  turtle.forward()
  turtle.turnLeft()
  while locate().y ~= loader_pos.y do
    turtle.down()
  end
  while locate().x ~= loader_pos.x do
    turtle.forward()
  end
end

local function recall()
  while locate().x ~= initial_pos.x do
    turtle.back()
  end
  while locate().y ~= initial_pos.y do
    turtle.up()
  end
  turtle.turnRight()
  turtle.back()
end

---@param req {slot: integer, count: integer}
local function request(req)
  turtle.select(req.slot)
  turtle.drop()
  for _ = 1, req.count do
    rs.setOutput("top", true)
    sleep(0.2)
    rs.setOutput("top", false)
    sleep(0.2)
  end
  rs.setOutput("bottom", true)
  sleep(0.2)
  rs.setOutput("bottom", false)
  while turtle.getItemCount(req.slot) ~= 1 do
    sleep(1)
  end
end

local function main()
  rednet.open("right")
  while true do
    local _, _, message_json = os.pullEvent("rednet_message")
    local message = json.unstringify(message_json)
    if type(items[message.item]) == "number" then
      dock()
      request({slot = items[message.item], count = message.count})
      recall()
    end
  end
end

main()