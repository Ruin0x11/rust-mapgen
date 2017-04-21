function make_grid()
   local grid = {}
   for i = 0, wrl.width() - 1, 1 do
      grid[i] = {}
      for j = 0, wrl.height() - 1, 1 do
         grid[i][j] = false
      end
   end
   return grid
end

function spray_map(alive_chance, terrain)
   for p in iter.map_iterator() do
      if rand.chance(alive_chance) then
         wrl.set(p, terrain)
      end
   end
end

function alive_neighbors(pos, alive_terrain)
   local count = 0
   for adj in iter.adjacent_iterator_to(pos) do
      if adj.x < 0 or adj.y < 0 or adj.x >= wrl.width() or adj.y >= wrl.height() then
         count = count + 1
      elseif wrl.get(adj) == alive_terrain then
         count = count + 1
      end
   end
   return count
end

function step_automata(alive_terrain, dead_terrain, dead_limit)
   local grid = make_grid()
   for p in iter.map_iterator() do
      local res = alive_neighbors(p, alive_terrain) >= dead_limit
      grid[p.x][p.y] = res
   end
   remake(grid, alive_terrain, dead_terrain)
end

function remake(grid, alive_terrain, dead_terrain)
   wrl.new(wrl.width(), wrl.height(), dead_terrain)
   for p in iter.map_iterator() do
      if grid[p.x][p.y] == true then
         wrl.set(p, alive_terrain)
      end
   end
end

function automata(w, h, alive_terrain, dead_terrain, alive_chance, dead_limit, iterations)
   wrl.new(w, h, dead_terrain)
   local count
   spray_map(alive_chance, alive_terrain)
   wrl.print_result()
   for count = 1, iterations, 1 do
      step_automata(alive_terrain, dead_terrain, dead_limit)
      wrl.print_result()
   end
end

function place_treasure(alive_terrain, treasure, threshold)
   for p in iter.map_iterator(function(p)
         return not wrl.blocked(p) and alive_neighbors(p, alive_terrain) >= threshold
   end) do
      wrl.set(p, treasure)
   end
end

-- automata(10, 40, "Floor", "Wall", 0.45, 4, 2)
-- place_treasure("Wall", "Important", 5)
-- wrl.print_result()
