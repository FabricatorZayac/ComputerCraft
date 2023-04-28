local Message = require("message")
local Queue = require("queue")
local json = require("json")

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
  repeat until not event_queue:isEmpty()
  return Message.fromtable(json.decode(event_queue:pop()[2]))
end

local function containsFilter(item)
  return type(items[item]) == "number"
end

local function wait_for_unlock()
  repeat until getMessage():match { SEMAPHORE_UNLOCK = true }
end

local function main()
  rednet.open("right")
  while true do
    local msg = getMessage()
    msg:match {
      SEMAPHORE_LOCK = wait_for_unlock(),
      ITEM_REQUEST = {
        {"item", "count"},
        function (item, count)
          if not containsFilter(item) then return end
          rednet.broadcast(json.encode(Message.SEMAPHORE_LOCK()))
          dock()
          while true do
            request({
              slot = items[item],
              count = count
            })
            if event_queue:isEmpty() then break end
            msg = event_queue:pop()
          end
          recall()
          rednet.broadcast(json.encode(Message.SEMAPHORE_UNLOCK()))
        end,
      },
    }
  end
end

parallel.waitForAll(listen, main)
