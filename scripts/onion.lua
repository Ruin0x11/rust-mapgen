function onion(xlocs, ylocs, layers)
   for p in iter.border_iterator(wrl.point(0, 0), wrl.size()) do
      wrl.set(p, "Wall")
   end
   local i, l, x1, x2, y1, y2
   for l = 0, layers, 1 do
      y1 = math.floor(ylocs[l])
      y2 = math.floor(ylocs[2 * layers - l - 1])
      for i = math.floor(xlocs[l]), xlocs[2 * layers - l - 1] do
         wrl.set_raw(i, y1, "Wall")
         wrl.set_raw(i, y2, "Wall")
         wrl.print_result()
      end

      x1 = math.floor(xlocs[l])
      x2 = math.floor(xlocs[2 * layers - l - 1])
      for i = math.floor(ylocs[l]), ylocs[2 * layers - l - 1] do
         wrl.set_raw(x1, i, "Wall")
         wrl.set_raw(x2, i, "Wall")
         wrl.print_result()
      end
   end
end

function do_onion(layers, is_random, rand_callback, nonrandom_callback)
   local w = wrl.width()
   local h = wrl.height()

   local maxlayers = math.floor((math.min(w, h) - 2) / 5)
   if maxlayers == 0 then error("Room too small to onionize") end
   if layers > maxlayers then layers = maxlayers end
   if layers == 0 then layers = rand.range(1, maxlayers) end

   local xlocs = {}
   local ylocs = {}

   if random then
      rand_callback(layers, xlocs, ylocs)
   else
      nonrandom_callback(layers, xlocs, ylocs)
   end

   onion(xlocs, ylocs, layers)
end

function onion_centered_nonrandom(layers, xlocs, ylocs)
   local xpitch = (wrl.width() - 2.0)/(2.0* layers + 1.0)
   local ypitch = (wrl.height() - 2.0)/(2.0 * layers + 1.0)
   xlocs[0] = xpitch
   ylocs[0] = ypitch
   for i = 1, 2 * layers, 1 do
      xlocs[i] = xlocs[i-1] + xpitch
      ylocs[i] = ylocs[i-1] + ypitch
   end
end

function onion_brc_nonrandom(layers, xlocs, ylocs)
   local xpitch = (wrl.width() - 2.0)/(2.0* layers + 1.0)
   local ypitch = (wrl.height() - 2.0)/(layers + 1.0)
   xlocs[0] = xpitch
   ylocs[0] = ypitch
   local i
   for i = 1, 2 * layers, 1 do
      if i < layers then
         xlocs[i] = xlocs[i-1] + xpitch
         ylocs[i] = ylocs[i-1] + ypitch
      else
         xlocs[i] = wrl.width() - 1
         ylocs[i] = wrl.height() - 1
      end
   end
end

function onion_centered(layers, random)
   do_onion(layers, random, onion_centered_nonrandom, onion_centered_nonrandom)
end

function onion_brc(layers, random)
   do_onion(layers, random, onion_brc_nonrandom, onion_brc_nonrandom)
end
