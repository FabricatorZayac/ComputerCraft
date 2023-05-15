while true do
    local _, message = os.pullEvent("rednet_receive")
    if message == "place" then
        turtle.place()
    end
end