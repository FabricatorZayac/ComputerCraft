local function spread(n_items, n_furnaces)
  for _ = 1, n_furnaces do
    turtle.forward()
    turtle.dropDown(n_items / n_furnaces)
  end
  for _ = 1, n_furnaces do
    turtle.back()
  end
end

local function flush()
  for i = 1, 16 do
    turtle.select(i)
    turtle.dropDown()
  end
end

local function main()
  while true do
    turtle.select(1)
    if turtle.getItemCount() >= 64 then
      spread(64, 8)
      flush()
    end
    turtle.suckDown()
    sleep(5)
  end
end

main()
