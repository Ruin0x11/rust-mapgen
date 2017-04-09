require("scripts/automata")
automata(100, 100, "Floor", "Wall", 0.45, 4, 2)
place_treasure("Wall", "Important", 5)
wrl.print_result()
