local json = require("json")

local trunkId = 0;

local ws, err = http.websocket("ws://diaco.strangled.net:4444", { id = "trunk" })

local function log(str)
  print(str)
  ws.send(str)
end

if err then
  print(err)
else
  print("[INFO] CONNECTED")
  ws.send(json.encode({
    messageType = "JOIN",
    trunkId = trunkId,
  }))

  local running = true
  while running do
    local msg = json.decode(ws.receive())
    if msg.IsFromPanel then
      log(">".. msg.Body)
      local argv = {}
      for i in msg.Body:gmatch("%w+") do
        table.insert(argv, i)
      end
      if argv[1] == "stop" then
        log("[INFO] stopping trunk")
        ws.close()
        return
      elseif argv[1] == "echo" then
        log(argv[2])
      else
        log("[INFO] Invalid command")
      end
    end
  end
end
