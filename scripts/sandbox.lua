require("scripts/automata")
require("scripts/streamer")

function collapsed_cave(w, h)
   automata(w, h, "Floor", "Wall", 0.45, 4, 2)
   place_treasure("Wall", "Important", 5)
   for i=1, 5, 1 do
      streamer_b(wrl.point(rand.zero_to(wrl.width()), rand.zero_to(wrl.height())), "Wall", 11, 8)
   end
end
