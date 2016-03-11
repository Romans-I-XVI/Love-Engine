Timer = {}
Timer.__index = Timer

function Timer.new()
	local data = {
		timestamp = love.timer.getTime()
	}
	return setmetatable(data, Timer)
end

function Timer:mark()
	self.timestamp = love.timer.getTime()
end

function Timer:getTotalMilliseconds()
	return 1000 * (love.timer.getTime() - self.timestamp)
end

function Timer:getTotalSeconds()
	return love.timer.getTime() - self.timestamp
end

setmetatable(Timer, { __call = function(_, ...) return Timer.new(...) end })