Object = {}
Object.__index = Object

function Object.new(name)
	local object = {
		name = name or "",
		id = objectHandler.SetID(),
		x = 0,
		y = 0,
        colliders = {},
        images = {},
		data = {}
	}
	local object = setmetatable(object, Object)
	objectHandler.Add(object)
	return object
end

function Object:onCollision(collider_name, other_object)
end

function Object:onUpdate(dt)
end

function Object:onDrawBegin()
end

function Object:onDrawEnd()
end

function Object:onKeyPress(key)
end

function Object:onKeyRelease(key)
end

function Object:onMousePress(x, y, button)
end

function Object:onMouseRelease(x, y, button)
end

function Object:onDestroy()
end

function Object:addColliderCircle(name, radius, offset_x, offset_y, active)
	local collider = {
		type = "circle",
		active = active or true,
		radius = radius,
		offset_x = offset_x or 0,
		offset_y = offset_y or 0,
	}
	if self.colliders[name] == nil then self.colliders[name] = collider else print("Collider Name Already Exists") end
end

function Object:addColliderRectangle(name, width, height, offset_x, offset_y, active)
	local collider = {
		type = "rectangle",
		active = active or true,
		offset_x = offset_x or 0,
		offset_y = offset_y or 0,
		width = width,
		height = height,
	}
	if self.colliders[name] == nil then self.colliders[name] = collider else print("Collider Name Already Exists") end
end

function Object:removeCollider(name)
	if self.colliders[name] ~= nil then self.colliders[name] = nil else print("Collider Doesn't Exist") end
end

function Object:addImage(name, image, depth, scale_x, scale_y, offset_x, offset_y, origin_x, origin_y, rotation, active)
	local image = {
		image = image,
		offset_x = offset_x or 0,
		offset_y = offset_y or 0,
		origin_x = origin_x or 0,
		origin_y = origin_y or 0,
		scale_x = scale_x or 1,
		scale_y = scale_y or 1,
		rotation = rotation or 0,
		depth = depth or 0,
		active = active or true
	}
	if self.images[name] == nil then self.images[name] = image else print("Collider Name Already Exists") end
end

function Object:removeImage(name)
	if self.images[name] ~= nil then self.images[name] = nil else print("Image Doesn't Exist") end
end


setmetatable(Object, { __call = function(_, ...) return Object.new(...) end })