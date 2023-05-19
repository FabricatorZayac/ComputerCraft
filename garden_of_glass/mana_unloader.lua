local pumping = false
while true do
  rs.setOutput("top", not pumping)
  os.pullEvent("redstone")
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
