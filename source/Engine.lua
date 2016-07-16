Game = {
	debug = false,
	paused = false,
	currentID = 0,
	currentRoom = nil,
	currentRoomArgs = {},
	Instances = {},
	Objects = {},
	Bitmaps = {}
}

function Game:Update(dt)
	all_instances = {}

	local count = 1
	for _, object_type in pairs(self.Instances) do
		for _, instance in pairs(object_type) do
			table.insert(all_instances, instance)
		end
	end

	local index = 2
	for i=1, #all_instances do
		-- Execute onUpdate on all instances
		local instance = all_instances[i]
		local collider = all_instances[i].collider
		instance.x = instance.x + instance.xspeed * dt
		instance.y = instance.y + instance.yspeed * dt
		instance:onUpdate(dt)

		-- Check collision with other instances
		for k=index, #all_instances do
			local in_collision = false
			local other_instance = all_instances[k]
			local other_collider = all_instances[k].collider

			if collider ~= nil and other_collider ~= nil and collider.active and other_collider.active then
				if collider.type == "rectangle" and other_collider.type == "rectangle" then
					in_collision = collisionFunction:RectRect(instance.x+collider.offset_x, instance.y+collider.offset_y, collider.width, collider.height, other_instance.x+other_collider.offset_x, other_instance.y+other_collider.offset_y, other_collider.width, other_collider.height)
				end
				if collider.type == "circle" and other_collider.type == "circle" then
					in_collision = collisionFunction:CircleCircle(instance.x+collider.offset_x, instance.y+collider.offset_y, collider.radius, other_instance.x+other_collider.offset_x, other_instance.y+other_collider.offset_y, other_collider.radius)
				end
				if (collider.type == "rectangle" and other_collider.type == "circle") or (collider.type == "circle" and other_collider.type == "rectangle") then
					local circle, circle_x, circle_y, rectangle, rectangle_x, rectangle_y
					if collider.type == "circle" then 
						circle_x = instance.x
						circle_y = instance.y
						circle = collider 
						rectangle_x = other_instance.x
						rectangle_y = other_instance.y
						rectangle = other_collider
					else 
						circle_x = other_instance.x
						circle_y = other_instance.y
						circle = other_collider 
						rectangle_x = instance.x
						rectangle_y = instance.y
						rectangle = collider
					end
					in_collision = collisionFunction:CircleRect(circle_x+circle.offset_x, circle_y+circle.offset_y, circle.radius, rectangle_x+rectangle.offset_x, rectangle_y+rectangle.offset_y, rectangle.width, rectangle.height)
				end
			end
			-- if in_collision and debug then print("Collision Detected: ",key, other_key, love.timer.getTime()) end
			if in_collision then 
				instance:onCollision(other_instance)
				other_instance:onCollision(instance)
			end
		end
	end
end

function Game:Draw()
	local depths = {}
	for _, object_type in pairs(self.Instances) do
		for _, instance in pairs(object_type) do
			if #depths > 0 then
				local inserted = false
				for i=#depths-1,1,-1 do
					if not inserted and instance.depth > depths[i].depth then
						table.insert(depths, i+1, instance)
						inserted = true
						break
					end
				end
				if not inserted then
				    table.insert(depths, 1, instance)
				end
			else
			    table.insert(depths, 1, instance)
			end
		end
	end

	for i=#depths,1,-1 do
		local instance = depths[i]
		local image = instance.image
		instance:onDrawBegin()
		if image ~= nil and image.active then
			love.graphics.draw(image.image, instance.x+image.offset_x, instance.y+image.offset_y, image.rotation, image.scale_x, image.scale_y, image.origin_x, image.origin_y)
		end
		instance:onDrawEnd()
		if self.debug then love.graphics.print(tostring(image.depth), instance.x-100, instance.y-100) end
	end
end

function Game:KeyPressed(key)
	for _, object_type in pairs(self.Instances) do
		for _, instance in pairs(object_type) do
			instance:onKeyPress(key)
		end
	end
end

function Game:KeyReleased(key)
	for _, object_type in pairs(self.Instances) do
		for _, instance in pairs(object_type) do
			instance:onKeyRelease(key)
		end
	end
end

function Game:MousePressed(x,y,button)
	for _, object_type in pairs(self.Instances) do
		for _, instance in pairs(object_type) do
			instance:onMousePress(x,y,button)
		end
	end
end

function Game:MouseReleased(x,y,button)
	for _, object_type in pairs(self.Instances) do
		for _, instance in pairs(object_type) do
			instance:onMouseRelease(x,y,button)
		end
	end
end

function Game:defineObject(object_name, object_creation_function)
	self.Objects[object_name] = object_creation_function
	self.Instances[object_name] = {}
end

function Game:createInstance(object_name, args)
	if self.Objects[object_name] ~= nil then
		new_instance = Object.new(object_name)
		self.Instances[object_name][new_instance.id] = new_instance
		self.Objects[object_name](new_instance)
		new_instance:onCreate(args or {})
		return new_instance
	else
		return nil
	end
end

function Game:getInstanceByName(object_name)
	if self.Instances[object_name] ~= nil then
		for _, instance in pairs(self.Instances[object_name]) do
			return instance
		end
	end
end

function Game:getAllInstances(object_name)
	if self.Instances[object_name] ~= nil then
		array = {}
		for _, instance in pairs(self.Instances[object_name]) do
			table.insert(array, instance)
		end
		return array
	else
		return nil
	end
end

function Game:destroyInstance(instance)
	if self.Instances[instance.name][instance.id] ~= nil then
		instance:onDestroy()
		table.remove(self.Instances[instance.name], instance.id)
	end
end

function Game:destroyAllInstances(object_name)
	for _, instance in pairs(self.Instances[object_name]) do
		self:destroyInstance(instance)
	end
end

function Game:instanceCount(object_name)
	return #self.Instances[object_name]
end
		