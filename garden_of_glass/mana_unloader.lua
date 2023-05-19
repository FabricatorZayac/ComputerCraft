local arg = ...
local log
if arg == "-v" then
  log = true
end

local pumping = false
while true do
  rs.setOutput("top", not pumping)
  os.pullEvent("redstone")
  if log then
    print(rs.getAnalogInput("back"))
  end
  if pumping then
    if rs.getAnalogInput("back") >= 13 then
      pumping = false
    end
  else
    if rs.getAnalogInput("back") <= 8 then
      pumping = true
    end
  end
end
