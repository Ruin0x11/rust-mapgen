function wrl.set(point, terrain)
   wrl.set_raw(point.x, point.y, terrain)
end

function wrl.get(point)
   return wrl.get_raw(point.x, point.y)
end

function wrl.blocked(point)
   return wrl.blocked_raw(point.x, point.y)
end

function wrl.in_bounds(point)
   return wrl.in_bounds_raw(point.x, point.y)
end

function wrl.size()
   return wrl.point(wrl.width() - 1, wrl.height() - 1)
end
