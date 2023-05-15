-- requires a birch block in second slot
local function treechop()
    turtle.select(2)
    while not turtle.compare() do
        sleep(10)
    end
    turtle.select(1)
    turtle.dig()
    turtle.forward()
    while turtle.detectUp() do
        turtle.digUp()
        turtle.up()
    end
    while not turtle.detectDown() do
        turtle.down()
    end
    turtle.back()
    sleep(1)
    rednet.send(15, "place")
end

local function turnAround()
    turtle.turnLeft()
    turtle.turnLeft()
end

local function dump()
    turtle.select(1)
    turnAround()
    turtle.forward()
    turtle.drop()
    turnAround()
    turtle.forward()
    turtle.select(2)
end

local function main()
    rednet.open("right")
    while true do
        if turtle.getItemCount(1) == 64 then
            dump()
        end
        treechop()
    end
end

main()