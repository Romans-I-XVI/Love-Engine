objectHolder = {}
objectHandler = {}
objectHandler.CurrentID = 0

function objectHandler.Update(dt)
	for _, object in pairs(objectHolder) do
		object:onUpdate(dt)
	end
end

function objectHandler.Draw()
	local depths = {}
	for key,object in pairs(objectHolder) do
		for image_key,image in pairs(object.images) do
			if #depths > 0 then
				local inserted = false
				for i=#depths,1,-1 do
					if not inserted and image.depth > depths[i].image.depth then
						table.insert(depths, i+1, {object = object, image = image})
						inserted = true
						break
					end
				end
				if not inserted then
				    table.insert(depths, 1, {object = object, image = image})
				end
			else
			    table.insert(depths, 1, {object = object, image = image})
			end
		end
	end

	for i=#depths,1,-1 do
		local object = depths[i].object
		local image = depths[i].image
		object:onDrawBegin()
		if image.active then
			love.graphics.draw(image.image, object.x+image.offset_x, object.y+image.offset_y, image.rotation, image.scale_x, image.scale_y, image.origin_x, image.origin_y)
		end
		object:onDrawEnd()
		if debug then love.graphics.print(tostring(image.depth), object.x-100, object.y-100) end
	end
end

function objectHandler.DrawColliders()
	love.graphics.setColor(255, 0, 0)
	for key,object in pairs(objectHolder) do
		for key, collider in pairs(object.colliders) do
			if collider.active then
				if collider.type == "circle" then
					love.graphics.circle("line", object.x+collider.offset_x, object.y+collider.offset_y, collider.radius, 100)
				end
				if collider.type == "rectangle" then
					love.graphics.rectangle("line", object.x+collider.offset_x, object.y+collider.offset_y, collider.width, collider.height)
				end
			end
		end
	end 
	love.graphics.setColor(255,255,255)
end

function objectHandler.CheckCollisions()
	for key, object in pairs(objectHolder) do
		for collider_key, collider in pairs(object.colliders) do
			for other_key, other_object in pairs(objectHolder) do
				if other_object ~= object then 
					for other_collider_key, other_collider in pairs(other_object.colliders) do
					    local in_collision = false
						if collider.type == "rectangle" and other_collider.type == "rectangle" then
							in_collision = collisionFunction:RectRect(object.x+collider.offset_x, object.y+collider.offset_y, collider.width, collider.height, other_object.x+other_collider.offset_x, other_object.y+other_collider.offset_y, other_collider.width, other_collider.height)
						end
						if collider.type == "circle" and other_collider.type == "circle" then
							in_collision = collisionFunction:CircleCircle(object.x+collider.offset_x, object.y+collider.offset_y, collider.radius, other_object.x+other_collider.offset_x, other_object.y+other_collider.offset_y, other_collider.radius)
						end
						if (collider.type == "rectangle" and other_collider.type == "circle") or (collider.type == "circle" and other_collider.type == "rectangle") then
							local circle, circle_x, circle_y, rectangle, rectangle_x, rectangle_y
							if collider.type == "circle" then 
								circle_x = object.x
								circle_y = object.y
								circle = collider 
								rectangle_x = other_object.x
								rectangle_y = other_object.y
								rectangle = other_collider
							else 
								circle_x = other_object.x
								circle_y = other_object.y
								circle = other_collider 
								rectangle_x = object.x
								rectangle_y = object.y
								rectangle = collider
							end
							in_collision = collisionFunction:CircleRect(circle_x+circle.offset_x, circle_y+circle.offset_y, circle.radius, rectangle_x+rectangle.offset_x, rectangle_y+rectangle.offset_y, rectangle.width, rectangle.height)
						end
						-- if in_collision and debug then print("Collision Detected: ",key, other_key, love.timer.getTime()) end
						if in_collision and collider.active then object:onCollision(other_collider_key, other_object) end
					end
				end
			end
		end
	end
end

function objectHandler.KeyPressed(key)
	for _, object in pairs(objectHolder) do
		object:onKeyPress(key)
	end
end

function objectHandler.KeyReleased(key)
	for _, object in pairs(objectHolder) do
		object:onKeyRelease(key)
	end
end

function objectHandler.MousePressed(x,y,button)
	for _, object in pairs(objectHolder) do
		object:onMousePress(x,y,button)
	end
end

function objectHandler.MouseReleased(x,y,button)
	for _, object in pairs(objectHolder) do
		object:onMouseRelease(x,y,button)
	end
end

-- Give a unique identifier to the object
function objectHandler.SetID()
	objectHandler.CurrentID = objectHandler.CurrentID + 1
	return objectHandler.CurrentID
end

-- Add an object to the objectHandler
function objectHandler.Add(object)
	if debug then print("Adding Object: "..tostring(object.id)) end
	objectHolder[object.id] = object
end

-- Remove an object from the objectHandler
function objectHandler.Remove(object)
	if debug then print("Removing Object: "..tostring(object.id)) end
	objectHolder[object.id] = nil
end