---@diagnostic disable: undefined-global
local message = require("message")
local Message = message.Message
local Queue = require("queue")

local event_queue = Queue.new()

local function listen()
  while true do
    event_queue:push({rednet.receive()})
  end
end

local function locate()
  local x, z, y = gps.locate(5)
  return {x = x, z = z, y = y}
end

local initial_pos = locate()
local loader_pos = {x = 268, z = 450, y = 60}

local items = {
    ingotIron = 1, nil, nil,
    nil,           nil, nil,
    nil,           nil, nil,
}

local function dock()
  turtle.forward()
  turtle.turnLeft()

  local dy = locate().y - loader_pos.y
  local dx = locate().x - loader_pos.x

  for _ = 1, math.abs(dy) do
    turtle.down()
  end
  for _ = 1, math.abs(dx) do
    turtle.forward()
  end
end

local function recall()
  local dy = locate().y - initial_pos.y
  local dx = locate().x - initial_pos.x

  for _ = 1, math.abs(dx) do
    turtle.back()
  end
  for _ = 1, math.abs(dy) do
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

local function getMessage()
  while event_queue:isEmpty() do
    sleep(1)
  end
  return json.unstringify(event_queue:pop()[2])
end

local function containsFilter(item)
  return type(items[item]) == "number"
end

local function main()
  rednet.open("right")
  while true do
    local msg = getMessage()
    if msg.msg == Message.SEMAPHORE_LOCK then
      while true do
        msg = getMessage()
        if msg.msg == Message.SEMAPHORE_UNLOCK then break end
      end
    elseif msg.msg == Message.ITEM_REQUEST and containsFilter(msg.body.item) then
      rednet.broadcast(message.json(Message.SEMAPHORE_LOCK))
      dock()
      repeat
        request({
          slot = items[msg.body.item],
          count = msg.body.count
        })
        msg = getMessage()
      until not containsFilter(msg.body.item)
      recall()
      rednet.broadcast(message.json(Message.SEMAPHORE_UNLOCK))
    end
  end
end

parallel.waitForAll(listen, main)
