function dir_offset(dir)
   local step
   if dir == 0 then return wrl.point(0, -1) end
   if dir == 1 then return wrl.point(-1, 0) end
   if dir == 2 then return wrl.point(1,  0) end
   if dir == 3 then return wrl.point(0,  1) end
   return wrl.point(0, 0)
end

function attempt_random_wall(min_length, max_length, granularity)
   local wall_pos = select_wall_start(granularity);
   local dir = rand.zero_to(4)
   local length = rand.between(min_length, max_length)
   length = length * granularity + 1
   draw_wall(wall_pos, dir, length)
end

function draw_wall(start, dir, length)
   local step = dir_offset(dir)

   local current = start
   for i = 1, length, 1 do
      if wrl.blocked(current) then return end
      wrl.set(current, "Wall")
      current = current + step
   end
end

function select_wall_start(granularity)
   local start
   local target = wrl.point(wrl.width() / granularity, wrl.width() / granularity)
   start = wrl.point(granularity * rand.zero_to(target.x),
                    granularity * rand.zero_to(target.y))
   return start
end

function maze(min_length, max_length, granularity, wall_count)
   local count
   for count = 1, wall_count, 1 do
      attempt_random_wall(min_length, max_length, granularity)
   end
end
