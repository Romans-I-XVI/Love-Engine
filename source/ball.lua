Ball = {}
Ball.__index = Ball
holderBalls = {}

function Ball.new(x, y, xspeed, yspeed, radius)
	local x = x or math.random(love.graphics.getWidth())
	local y = y or math.random(love.graphics.getHeight())
	local xspeed = xspeed or math.random(200)-100
	local yspeed = yspeed or math.random(200)-100
	local radius = radius or math.random(80)

	local ball = Object("ball")
	ball.x = x
	ball.y = y
	ball.data = {
		radius = radius,
		collided = false,
		collided_with = {},
		mass = 100*(radius/32),
		xspeed = xspeed,
		yspeed = yspeed,
		in_collision_with = {}
	}

	ball:addColliderCircle("main", radius, 0, 0)
	ball:addImage("ball", bm_ball, math.random(1000)-1000, 1*(radius/32), 1*(radius/32), 0, 0, 100, 100)

	function ball:onCollision(collider_name, other_object)
		-- Process bounces
		if other_object.name == "ball" or (other_object.name == "player" and collider_name == "main") then 
			local contact_position = AdjustPosition(self, other_object)
			local already_in_collision = false
			for previous_key,previous_collision_object in pairs(self.data.in_collision_with) do
				if previous_collision_object == other_object then
				    already_in_collision = true
				end
			end
			if not already_in_collision then 
				local collision_position, impact_force = ManageBounce(self, other_object)
				if collision_position ~= nil then
					table.insert(self.data.in_collision_with, other_object)
					table.insert(other_object.data.in_collision_with, self)
				end
			end
		end
	end

	function ball:onUpdate(dt)

		-- Remove previous collision if no longer in collision
		for other_key,other_object in pairs(self.data.in_collision_with) do
			if not collisionFunction:CircleCircle(self.x+self.colliders.main.offset_x, self.y+self.colliders.main.offset_y, self.colliders.main.radius, other_object.x+other_object.colliders.main.offset_x, other_object.y+other_object.colliders.main.offset_y, other_object.colliders.main.radius) then
				table.remove(self.data.in_collision_with, other_key)
			end
		end

		-- Handle Movement
		self.x = self.x + (self.data.xspeed*dt)
		self.y = self.y + (self.data.yspeed*dt)
		if self.x-self.colliders["main"].radius <= 0 then
		    self.data.xspeed = math.abs(self.data.xspeed)
		end
		if self.x+self.colliders["main"].radius >= Camera.width then
			self.data.xspeed = math.abs(self.data.xspeed)*-1
		end
		if self.y-self.colliders["main"].radius <= 0 then
		    self.data.yspeed = math.abs(self.data.yspeed)
		end
		if self.y+self.colliders["main"].radius >= Camera.height then
			self.data.yspeed = math.abs(self.data.yspeed)*-1
		end
	end

	return ball
end

setmetatable(Ball, { __call = function(_, ...) return Ball.new(...) end })