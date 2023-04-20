Queue = {}

function Queue:push(value)
  local last = self.last + 1
  self.last = last
  self[last] = value
end

function Queue:pop()
  local first = self.first
  if first > self.last then error("queue is empty") end
  local value = self[first]
  self[first] = nil        -- to allow garbage collection
  self.first = first + 1
  return value
end

function Queue:isEmpty()
  return self.first > self.last
end

function Queue.new()
  local self = {
    first = 0,
    last = -1,
    push = Queue.push,
    pop = Queue.pop,
    isEmpty = Queue.isEmpty,
  }
  return self
end

return Queue
