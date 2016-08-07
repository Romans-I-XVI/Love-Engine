Object = {}
Object.__index = Object

function Object.new(name)
	Game.currentID = Game.currentID + 1
	local object = {
		name = name or "",
		id = tostring(Game.currentID),
		depth = 0,
		x = 0,
		y = 0,
		xspeed = 0,
		yspeed = 0,
        collider = nil,
        image = nil,
	}
	local object = setmetatable(object, Object)
	return object
end

function Object:onCreate(args)
end

function Object:onCollision(other_object)
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

function Object:addColliderCircle(radius, offset_x, offset_y, active)
	local collider = {
		type = "circle",
		active = active or true,
		radius = radius,
		offset_x = offset_x or 0,
		offset_y = offset_y or 0,
	}
	self.collider = collider
end

function Object:addColliderRectangle(width, height, offset_x, offset_y, active)
	local collider = {
		type = "rectangle",
		active = active or true,
		offset_x = offset_x or 0,
		offset_y = offset_y or 0,
		width = width,
		height = height,
	}
	self.collider = collider
end

function Object:removeCollider()
	self.collider = nil
end

function Object:addImage(image, properties)
	properties = properties or {}
	local image = {
		image = image,
		offset_x = properties.offset_x or 0,
		offset_y = properties.offset_y or 0,
		origin_x = properties.origin_x or 0,
		origin_y = properties.origin_y or 0,
		scale_x = properties.scale_x or 1,
		scale_y = properties.scale_y or 1,
		rotation = properties.rotation or 0,
		active = properties.active or true
	}
	self.image = image
end

function Object:removeImage(name)
	self.image = nil
end


setmetatable(Object, { __call = function(_, ...) return Object.new(...) end })