function rect_cavern(buffer, upper_left, lower_right)
   local start = wrl.point(lower_right.x - upper_left.x - buffer,
                           lower_right.y - upper_left.y - buffer)
   if start.x < 12 or start.y < 12 then return end

   local k = start.x * start.y / 20
   for i = 0, k, 1 do
      now = wrl.point(
         buffer + upper_left.x + 5 + rand.zero_to(start.x - 10),
         buffer + upper_left.y + 5 + rand.zero_to(start.y - 10)
      )
      offset = rand.dir4()
      for j = 0, 5, 1 do
         current = now + (offset * j)
         wrl.set(current, "Floor")
      end
   end

   for p in iter.rect_iterator(upper_left, lower_right) do
      local found = false
      for adj in iter.adjacent_iterator_to(p) do
         if wrl.in_bounds(adj) and wrl.get(adj) == "Floor" then
            found = true
         end
      end
      if found and wrl.get(p) == "Wall" then
         wrl.set(p, "Important")
      end
   end
end

function do_castle(x1, y1, x2, y2)
   return x1, y1, x2, y2, o, d
end

function castle(area)
   local start = wrl.point(area:right() - area:x(),
                           area:bottom() - area:y())
   if start.x < 7 or start.y < 7 then return end
   print(start)

   local x1 = area:x()
   local y1 = area:y()
   local x2 = area:width()
   local y2 = area:height()
   local o = 0
   local d = 0
   local room_a, room_b

   if rand.chance(0.9) or (start.x > start.y and rand.chance(1/9)) then
      repeat
         o = o + 1
         d = x1 + 2 + rand.zero_to(x2 - x1 + 2)
      until ((wrl.blocked_raw(d, y1) and wrl.blocked_raw(d, y2)) or o > 10)

      o = y1 + 1 + rand.zero_to(y2 - y1 + 2)
      for i = y1 + 1, y2, 1 do
         if i ~= o then
            wrl.set_raw(d, i, "Wall")
         end
      end
      room_a = wrl.rect(x1, y1, d, y2)
      room_b = wrl.rect(d, y1, x2, y2)
      wrl.set_raw(d, o, "Important")
   else
      repeat
         o = o + 1
         d = y1 + 2 + rand.zero_to(y2 - y1 + 2)
      until ((wrl.blocked_raw(x1, d) and wrl.blocked_raw(x2, d)) or o > 10)

      o = x1 + 1 + rand.zero_to(x2 - x1 + 2)
      for i = x1 + 1, x2, 1 do
         if i ~= o then
            wrl.set_raw(i, d, "Wall")
         end
      end
      room_a = wrl.rect(x1, y1, x2, d)
      room_b = wrl.rect(x1, d, x2, y2)
      wrl.set_raw(o, d, "Important")
   end

   wrl.print_result()

   castle(room_a)
   castle(room_b)
end
