require("table")
require("scripts/automata")

rooms = {}

function create_room(pos, mwidth, mheight, something, index)
   local a, b, c

   if index == 0 then
      a = 0
      b = 0
      c = 0
   elseif index == 1 then
      a = 1
      b = 1
      c = 0
   elseif index == 2 then
      a = 2
      b = 1
      c = 1
   elseif index == 3 then
      a = 3
      b = 2
      c = 3
   elseif index == 4 then
      a = 4
      b = 3
      c = 0
   end

   local size = 30
   local x, y, w, h
   local blah = 10
   local xoff, yoff
   local i
   local found = false

   for i = 0, 100, 1 do
      if a == 0 then
         w = rand.zero_to(blah) + something
         h = rand.zero_to(blah) + something
         x = rand.zero_to(mwidth) + 2
         y = rand.zero_to(mheight) + 2
      elseif a == 1 then
         w = rand.zero_to(blah) + something / 3 * 3 + 5
         h = rand.zero_to(blah) + something / 3 * 3 + 5
         x = rand.zero_to(mwidth) / 3 * 3 + 2
         y = rand.zero_to(mheight) / 3 * 3 + 2
      elseif a == 2 then
         local variant = rand.zero_to(4)
         if variant == 3 or variant == 0 then
            x = rand.zero_to(mwidth - something * 3 / 2 - 2) + something / 2
            w = rand.zero_to(something) + something / 2 + 3
            h = something
            if variant == 3 then
               y = 0
            else
               y = mheight - h
            end
         elseif variant == 1 or variant == 2 then
            y = rand.zero_to(mheight - something * 3 / 2 - 2) + something / 2
            w = rand.zero_to(something) + something / 2 + 3
            h = something
            if variant == 3 then
               x = 0
            else
               x = mwidth - w
            end
         end
         -- Pillar
      elseif a == 3 then
         w = 3
         h = 3
         xoff = mwidth - something * 2 - w - 2 + 1
         if xoff < 1 then break end
         yoff = mheight - something * 2 - w - 2 + 1
         if yoff < 1 then break end
         x = something + 1 + rand.zero_to(xoff)
         y = something + 1 + rand.zero_to(yoff)
      elseif a == 4 then
         w = rand.zero_to(blah) + something
         h = rand.zero_to(blah) + something
         x = rand.zero_to(mwidth - blah - 8) + 3
         y = rand.zero_to(mheight - blah - 8) + 3
      end
      xoff = x + w - 1
      yoff = y + h - 1
      if xoff >= mwidth then goto continue end
      if yoff >= mheight then goto continue end

      if a == 1 then
         if xoff + 1 >= mwidth then goto continue end
         if yoff + 1 >= mheight then goto continue end
      elseif a == 0 then
         -- something
      end

      local rest
      for rest = 1, #rooms, 1 do
         local other = rooms[rest]
         local diffx = other[1] - 1 - x
         local diffy = other[2] - 1 - y

         local x_safe = -other[3] - 2 < diffx and diffx < w
         local y_safe = -other[4] - 2 < diffy and diffy < h

         local test = wrl.rect(x, y, w, h)
         if test:intersects(other) then
            goto continue
         end
      end
      found = true
      break
      ::continue::
   end
   if not found then return end
   local somex = 0
   local somey = 0
   local aflag = 0
   local itemx, itemy

   local upper_left = wrl.point(x, y)
   local bottom_right = wrl.point(w, h)

   for p in iter.border_iterator(upper_left, upper_left + bottom_right) do
      wrl.set(p, "Wall")
   end
   wrl.print_result()

   room = wrl.rect(upper_left.x, upper_left.y, bottom_right.x, bottom_right.y)
   print("insert")
   table.insert(rooms, room)

   if rand.chance(1/3) then somex = 1 + rand.zero_to(2) end
   if rand.chance(1/3) then somey = 1 + rand.zero_to(2) end
   for dy = 0, h, 1 do
      itemy = upper_left.y + dy
      for dx = 0, w, 1 do
         itemx = upper_left.x + dx
         aflag = 3
         if b ~= 0 then
            if dx == 0 or dy == 0 or dx == w - 1 or dy == h - 1 then
               if b == 1 then
                  aflag = 1
               elseif b == 2 then
                  aflag = 4
               elseif b == 3 then
                  aflag = 3
                  if somex == 1 and dx == 0 then
                     aflag = 1
                  end
                  if somey == 1 and dy == 0 then
                     if dx ~= 0 and dx ~= w - 1 then
                        if rand.chance(1/3) then
                           wrl.set_raw(itemx, itemy, "Important")
                        elseif dx / 2 == 1 then
                           wrl.set_raw(itemx, itemy, "Important")
                        end
                     end
                     aflag = 1
                  end
               end
               if somex == 2 and dx == w - 1 then
                  aflag = 1
               end
               if somey == 2 and dy == h - 1 then
                  if rand.chance(1/3) then
                     wrl.set_raw(itemx, itemy, "Important")
                  elseif dx / 2 == 1 then
                     wrl.set_raw(itemx, itemy, "Important")
                  end
                  aflag = 1
               end
            end
         end

      end
   end

   if c == 1 then
      -- door
   elseif c == 2 or c == 3 then
      for i = 1, 4, 1 do
         -- door
      end
   end
end

function party_room()
   local mwidth = 38
   local mheight = 28
   local something = 5

   local times
   local i, j

   for j = 0, mheight, 1 do
      for i = 0, mwidth, 1 do
         if i == 0 or j == 0 or i + 1 == mwidth or j + 1 == mheight then
            goto continue
         end
         wrl.set_raw(i, j, "Nothing")
         ::continue::
      end
   end

   for times = 0, 80, 1 do
      create_room(wrl.point(0, 0), mwidth, mheight, something, 4)
   end

   local itemx, itemy

   for times = 0, 500, 1 do
      local somex = rand.zero_to(mwidth - 5)
      local somey = rand.zero_to(mheight - 5)
      local flaga = true
      local flagb = false
      for j = 0, 4, 1 do
         itemy = somey + j
         for i = 0, 4, 1 do
            itemx = somex + i
            if false then
               flaga = false
            end
            if false then
               flagb = false
            end
         end
      end
      if flaga then
         local variant = rand.zero_to(5)
         for j = 0, 4, 1 do
            local itemy = somey + j
            for i = 0, 4, 1 do
               local itemx = somex + i
               if variant < 2 then
                  if i ~= 0 and i ~=3 and j ~= 0 and j ~= 3 then
                  end
               end
            end
         end
      end
   end
end

wrl.new(100, 100, "Floor")
party_room()
wrl.print_result()
