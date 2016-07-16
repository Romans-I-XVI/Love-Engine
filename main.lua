debug = true
require "source.Engine"
require "source.Camera"
require "source.Object"
require "source.collisionFunctions"
require "source.Timer"

require "source.ball"

function love.load(arg)
	math.randomseed(os.clock())
	Game.Bitmaps["ball"] = love.graphics.newImage("sprites/ball.png")
	Game:createInstance("ball", {xspeed = 50, yspeed = 50})
	Game:createInstance("ball", {xspeed = 100, yspeed = 50})
	Game:createInstance("ball", {xspeed = 50, yspeed = 100})
	-- Game:createInstance("ball")
end

function love.keypressed(key)
	-- Run the onKeyPress() function in all objects
	Game:KeyPressed(key)
end

function love.keyreleased(key)
	-- Run the onKeyRelease() function in all objects
	Game:KeyReleased(key)
end

function love.mousepressed(x,y,button)
	-- Run the onMousePress() function in all objects
	Game:MousePressed(x,y,button)
end

function love.mousereleased(x,y,button)
	-- Run the onMouseRelease() function in all objects
	Game:MouseReleased(x,y,button)
end

function love.update(dt)
	-- Run the onUpdate() function for all objects
	Game:Update(dt)
end

function love.draw(dt)
	Camera:set()

	-- Draw all of the objects in the objectHandler, also run the onDrawBegin() and onDrawEnd() functions
	Game:Draw()

	Camera:unset()
end
