collisionFunction = {}

function collisionFunction:RectRect(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function collisionFunction:CircleCircle(x1,y1,r1, x2,y2,r2)
	local dist = math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
    return dist <= r1 + r2
end

function collisionFunction:CircleRect( cx, cy, cr, rx, ry, rw, rh )
   local circle_distance_x = math.abs(cx - rx - rw/2)
   local circle_distance_y = math.abs(cy - ry - rh/2)

   if circle_distance_x > (rw/2 + cr) or circle_distance_y > (rh/2 + cr) then
      return false
   elseif circle_distance_x <= (rw/2) or circle_distance_y <= (rh/2) then
      return true
   end

   return (math.pow(circle_distance_x - rw/2, 2) + math.pow(circle_distance_y - rh/2, 2)) <= math.pow(cr, 2)
end