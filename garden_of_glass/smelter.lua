local function spread(n_items, n_furnaces)
  for _ = 1, n_furnaces do
    turtle.forward()
    turtle.dropDown(n_items / n_furnaces)
  end
  for _ = 1, n_furnaces do
    turtle.back()
  end
end

local function main()
  while true do
    turtle.select(1)
    turtle.suckDown()
    if turtle.getItemCount() == 64 then
      spread(64, 8)
    end
  end
end

main()
