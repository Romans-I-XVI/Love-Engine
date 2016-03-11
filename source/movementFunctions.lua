function ManageBounce(ball_1, ball_2)
	-- if debug then print("ManageBounce()") end
	-- ' Credits for this ManageBounce() function go to - http://www.emanueleferonato.com/2007/08/19/managing-ball-vs-ball-collision-with-flash/
	if ball_1 == nil then print("ball_1 is nil") ; return nil, nil end
	if ball_2 == nil then print("ball_2 is nil") ; return nil, nil end
	if ball_1.data.xspeed == nil then print("ball_1 has no xspeed data") ; return nil, nil end
	if ball_1.data.yspeed == nil then print("ball_1 has no yspeed data") ; return nil, nil end
	if ball_2.data.xspeed == nil then print("ball_2 has no xspeed data") ; return nil, nil end
	if ball_2.data.yspeed == nil then print("ball_2 has no yspeed data") ; return nil, nil end
	if ball_1.data.mass == nil then print("ball_1 has no mass data") ; return nil, nil end
	if ball_2.data.mass == nil then print("ball_1 has no mass data") ; return nil, nil end
	if ball_1.data.radius == nil then print("ball_1 has no radius data") ; return nil, nil end
	if ball_2.data.radius == nil then print("ball_2 has no radius data") ; return nil, nil end

	-- ' Save old x and y speeds for later
	local old_x_speed_1 = ball_1.data.xspeed
	local old_y_speed_1 = ball_1.data.yspeed
	local old_x_speed_2 = ball_2.data.xspeed
	local old_y_speed_2 = ball_2.data.yspeed

	-- ' Get the x and y distances between the balls.

	local dx = ball_1.x - ball_2.x
	local dy = ball_1.y - ball_2.y


	-- ' Get collision angle using atan2 simulation. 
	local collision_angle = math.atan2(dy, dx)


	-- ' Get magnitude using pythagorean theorem
	local magnitude_1 = math.sqrt(ball_1.data.yspeed^2+ball_1.data.xspeed^2)
	local magnitude_2 = math.sqrt(ball_2.data.yspeed^2+ball_2.data.xspeed^2)

	-- ' Get direction of ball 1 using atan2 simulation
	local direction_1 = math.atan2(ball_1.data.yspeed, ball_1.data.xspeed)

	-- ' Get direction of ball 2 using atan2 simulation
	local direction_2 = math.atan2(ball_2.data.yspeed, ball_2.data.xspeed)


	-- ' Solve for new velocities (other sides of triangle) using trigonometry 
	local new_xspeed_1 = magnitude_1*math.cos(direction_1-collision_angle)
	local new_yspeed_1 = magnitude_1*math.sin(direction_1-collision_angle)
	local new_xspeed_2 = magnitude_2*math.cos(direction_2-collision_angle)
	local new_yspeed_2 = magnitude_2*math.sin(direction_2-collision_angle)


	-- -- ' Factor in sizees to new velocities
	local mass_and_impact_1 = ball_1.data.mass --* 1 --this would normally be the impact multiplier
	local mass_and_impact_2 = ball_2.data.mass --* 1 --this would normally be the impact multiplier
	local final_xspeed_1 = ((ball_1.data.mass-mass_and_impact_2)*new_xspeed_1+(mass_and_impact_2+mass_and_impact_2)*new_xspeed_2)/(ball_1.data.mass+mass_and_impact_2)
	local final_xspeed_2 = ((mass_and_impact_1+mass_and_impact_1)*new_xspeed_1+(ball_2.data.mass-mass_and_impact_1)*new_xspeed_2)/(mass_and_impact_1+ball_2.data.mass)
	local final_yspeed_1 = new_yspeed_1
	local final_yspeed_2 = new_yspeed_2

	-- ' Do some magic
	ball_1.data.xspeed = math.cos(collision_angle)*final_xspeed_1+math.cos(collision_angle+math.pi/2)*final_yspeed_1
	ball_1.data.yspeed = math.sin(collision_angle)*final_xspeed_1+math.sin(collision_angle+math.pi/2)*final_yspeed_1
	ball_2.data.xspeed = math.cos(collision_angle)*final_xspeed_2+math.cos(collision_angle+math.pi/2)*final_yspeed_2
	ball_2.data.yspeed = math.sin(collision_angle)*final_xspeed_2+math.sin(collision_angle+math.pi/2)*final_yspeed_2

	-- if debug then 
	-- 	print("ball_1.x: ", ball_1.x)
	-- 	print("ball_1.y: ", ball_1.y)
	-- 	print("ball_2.x: ", ball_2.x)
	-- 	print("ball_2.y: ", ball_2.y)
	-- 	print("dx: ", dx)
	-- 	print("dy: ", dy)
	-- 	print("collision_angle: ", collision_angle)
	-- 	print("direction_1: ", direction_1)
	-- 	print("direction_2: ", direction_2)
	-- 	print("new_xspeed_1: ", new_xspeed_1)
	-- 	print("new_yspeed_1: ", new_yspeed_1)
	-- 	print("new_xspeed_2: ", new_xspeed_2)
	-- 	print("new_yspeed_2: ", new_yspeed_2)
	-- 	print("Old xspeed_1: ", old_x_speed_1, "New xspeed_1: ", ball_1.data.xspeed)
	-- 	print("Old yspeed_1: ", old_y_speed_1, "New yspeed_1: ", ball_1.data.yspeed)
	-- 	print("Old xspeed_2: ", old_x_speed_2, "New xspeed_2: ", ball_2.data.xspeed)
	-- 	print("Old yspeed_2: ", old_y_speed_2, "New yspeed_2: ", ball_2.data.yspeed)
	-- end


	local total_distance = math.sqrt(dx^2+dy^2)
	local percentage = ball_1.data.radius/total_distance
	local collision_position = {x = (ball_1.x)-(dx*percentage), y = (ball_1.y)-(dy*percentage)}
	local impact_force = (math.abs(ball_1.data.xspeed - old_x_speed_1)+math.abs(ball_1.data.yspeed - old_y_speed_1))*(ball_1.data.mass/100)

	return collision_position, impact_force
end

function AdjustPosition(ball_1, ball_2)
	-- if debug then print("AdjustPosition()") end

	-- The purpose of this functions is to manage cases where the ball enters into another ball. If the total distances between the two balls is less than it should be
	-- ball_1 is moved to where the original point of collision should have been (if we were in the real world that is).
	if ball_1 == nil then print("ball_1 is nil") ; return nil, nil end
	if ball_2 == nil then print("ball_2 is nil") ; return nil, nil end
	if ball_1.data.xspeed == nil then print("ball_1 has no xspeed data") ; return nil, nil end
	if ball_1.data.yspeed == nil then print("ball_1 has no yspeed data") ; return nil, nil end
	if ball_2.data.xspeed == nil then print("ball_2 has no xspeed data") ; return nil, nil end
	if ball_2.data.yspeed == nil then print("ball_2 has no yspeed data") ; return nil, nil end
	if ball_1.data.mass == nil then print("ball_1 has no mass data") ; return nil, nil end
	if ball_2.data.mass == nil then print("ball_1 has no mass data") ; return nil, nil end
	if ball_1.data.radius == nil then print("ball_1 has no radius data") ; return nil, nil end
	if ball_2.data.radius == nil then print("ball_2 has no radius data") ; return nil, nil end

	-- ' Get the x and y distances between the balls.
	local dx = ball_1.x - ball_2.x
	local dy = ball_1.y - ball_2.y

	-- ' Get collision angle using atan2 simulation. 
	local collision_angle = math.atan2(dy, dx)

	-- Get the total distance using pythagorean theorem
	local total_distance = math.sqrt(dx^2+dy^2)

	-- Set what the total distance should have been in the real world.
	local new_total_distance = ball_1.data.radius + ball_2.data.radius

	-- Adjust x and y distance to reflect new total distance.
	local new_dx = math.cos(collision_angle)*new_total_distance
	local new_dy = math.sin(collision_angle)*new_total_distance

	-- Update x and y positions
	local new_xpos_1 = new_dx + ball_2.x
	local new_ypos_1 = new_dy + ball_2.y
	local new_xpos_2 = new_dx*-1 + ball_1.x
	local new_ypos_2 = new_dy*-1 + ball_1.y

	local difference_xpos_1 = ball_1.x-new_xpos_1
	local difference_ypos_1 = ball_1.y-new_ypos_1
	local difference_xpos_2 = ball_2.x-new_xpos_2
	local difference_ypos_2 = ball_2.y-new_ypos_2
	local xspeed_adjustment_1 = new_xpos_1-ball_1.x
	local yspeed_adjustment_1 = new_ypos_1-ball_1.y
	local xspeed_adjustment_2 = new_xpos_2-ball_2.x
	local yspeed_adjustment_2 = new_ypos_2-ball_2.y



	-- Uncomment this to get an overview of the variables and the adjustments.
	-- print ("old_xpos = " , ball_1.x)
	-- print ("new_xpos = " , new_xpos_1)
	-- print ("old_ypos = " , ball_1.y)
	-- print ("new_ypos = " , new_ypos_1)
	-- print ("dx = " , dx)
	-- print ("new_dx = " , new_dx)
	-- print ("dy = " , dy)
	-- print ("new_dy = " , new_dy)
	-- print ("total_distance = " , total_distance)
	-- print ("total_distance should be: " , new_total_distance)
	-- print ("multiplier = " , (ball_1.data.radius + ball_2.data.radius)/total_distance)
	-- print ("-------------------------------")
	
	-- If the total distance between the balls is less than it should have been, return the new data so it can be added to the sprite.
	if total_distance < new_total_distance then
		ball_1.x = ball_1.x-difference_xpos_1/2
		ball_1.y = ball_1.y-difference_ypos_1/2
		ball_2.x = ball_2.x-difference_xpos_2/2
		ball_2.y = ball_2.y-difference_ypos_2/2
	end

	-- Get the impact position
	percentage = ball_1.data.radius/new_total_distance
	contact_position = {x = ball_1.x-(new_dx*percentage), y = ball_1.y-(new_dy*percentage)}
	return contact_position
end