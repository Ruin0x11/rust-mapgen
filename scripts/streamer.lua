function streamer(start, terrain, width, density)
   return streamer_i(start, terrain, width, density, width + 1, 2 * width + 1)
end

function streamer_b(start, terrain, width, density)
   return streamer_i(start, terrain, width, density, - 2 * width + 1, 2 * width + 1)
end

function streamer_i(start, terrain, width, density, w1, w2)
   local p = start

   local dir = rand.dir4()
   repeat
      local i
      for i = 1, density, 1 do
         local found = wrl.point(p.x + rand.between(w1, w2), p.y + rand.between(w1, w2))
         if wrl.in_bounds(found) then
            wrl.set(found, terrain)
         end
      end
      p = p + dir
   until not wrl.in_bounds(p)
end


-- for i=1, 5, 1 do
--    streamer_b(wrl.point(rand.zero_to(wrl.width()), rand.zero_to(wrl.height())), "Wall", 11, 8)
-- end
