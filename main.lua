debug = true
require "source.Camera"
require "source.objectHandler"
require "source.Object"
require "source.collisionFunctions"
require "source.movementFunctions"
require "source.Timer"
require "source.ball"

function love.load(arg)
	math.randomseed(os.clock())

	-- Create the ball bitmap
	bm_ball = love.graphics.newImage("sprites/test.png")

	-- Set the initial camera zone
	Camera:setLockedResolution(1280, 720)

	-- Create 20 bouncing balls
	for i=1,20 do
		table.insert(holderBalls, Ball())
	end
end

function love.keypressed(key)
	-- Create a new ball if "up" is pressed
	if key == "up" then
		table.insert(holderBalls, Ball())
	end

	-- Remove a ball if "down" is pressed. (Removes the last ball from the objectHandler first and then from the holderBall array)
	if key == "down" and #holderBalls > 0 then
		objectHandler.Remove(holderBalls[#holderBalls])
		table.remove(holderBalls, #holderBalls)
	end

	-- Run the onKeyPress() function in all objects
	objectHandler.KeyPressed(key)
end

function love.keyreleased(key)
	-- Run the onKeyRelease() function in all objects
	objectHandler.KeyReleased(key)
end

function love.mousepressed(x,y,button)
	-- Run the onMousePress() function in all objects
	objectHandler.MousePressed(x,y,button)
end

function love.mousereleased(x,y,button)
	-- Run the onMouseRelease() function in all objects
	objectHandler.MouseReleased(x,y,button)
end

function love.resize()
	-- Resize the Camera zone if the window gets resized
	Camera:setLockedResolution(1280, 720)
end

function love.update(dt)
	-- Run the onUpdate() function for all objects
	objectHandler.Update(dt)

	-- Run the onCollision() function for all objects
	objectHandler.CheckCollisions()
end

function love.draw(dt)
	Camera:set()

	-- Draw all of the objects in the objectHandler, also run the onDrawBegin() and onDrawEnd() functions
	objectHandler.Draw()

	-- If debug is enabled, draw all of the colliders
	if debug then objectHandler.DrawColliders() end

	-- If debug is enabled, show the Camera boundaries
	if debug then love.graphics.rectangle("line", 0, 0, Camera.width, Camera.height) end

	Camera:unset()
end
