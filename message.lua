local enum = require("enum").enum

Message = enum {
  ITEM_REQUEST = 1,
  SEMAPHORE_LOCK = 2,
  SEMAPHORE_UNLOCK = 3,
}

return {
  Message = Message,
  json = function(msg, body)
    return json.stringify({
      msg = msg,
      body = body,
    })
  end,
}
