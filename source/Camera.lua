Camera = {}
Camera.x = 0
Camera.y = 0
Camera.scaleX = 1
Camera.scaleY = 1
Camera.rotation = 0
Camera.width, Camera.height = love.window.getMode()

function Camera:set()
	love.graphics.push()
	love.graphics.rotate(self.rotation)
	love.graphics.translate(self.x, self.y)
	love.graphics.scale(self.scaleX, self.scaleY)
end

function Camera:unset()
	love.graphics.pop()
end

function Camera:move(dx, dy)
	self.x = self.x + (dx or 0)
	self.y = self.y + (dy or 0)
end

function Camera:rotate(dr)
	self.rotation = self.rotation + dr
end

function Camera:scale(sx, sy)
	sx = sx or 1
	self.scaleX = self.scaleX * sx
	self.scaleY = self.scaleY * (sy or sx)
end

function Camera:setPosition(x, y)
	self.x = x or self.x
	self.y = y or self.y
end

function Camera:setScale(sx, sy)
	self.scaleX = sx or self.scaleX
	self.scaleY = sy or self.scaleY
end

function Camera:setLockedResolution(w, h)
	self.width = w or self.width
	self.height = h or self.height
	local window_width, window_height, flags = love.window.getMode()
	if window_width/window_height < self.width/self.height then
		self.scaleX = window_width/self.width
		self.scaleY = self.scaleX
	    Camera:setPosition(0, (window_height-(window_width/(self.width/self.height)))/2)
	elseif window_width/window_height > self.width/self.height then
		self.scaleX = window_height/self.height
		self.scaleY = self.scaleX
		Camera:setPosition((window_width-(window_height*(self.width/self.height)))/2, 0)
	end	
end