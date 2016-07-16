Game:defineObject("ball",
	function(object)

		function object:onCreate(args)
			print(args)
			self.radius = 32
			self.x = args.x or 0
			self.y = args.y or 0
			self.xspeed = args.xspeed or 0
			self.yspeed = args.yspeed or 0
			self:addImage(Game.Bitmaps.ball, {origin_x = 100, origin_y = 100})
		end

		function object:onUpdate(dt)

			if self.x+self.radius > love.graphics.getWidth() then
				self.xspeed = math.abs(self.xspeed)*-1
			end

			if self.y+self.radius > love.graphics.getHeight() then
				self.yspeed = math.abs(self.yspeed)*-1
			end

			if self.x-self.radius < 0 then
				self.xspeed = math.abs(self.xspeed)
			end

			if self.y-self.radius < 0 then
				self.yspeed = math.abs(self.yspeed)
			end

		end

	end
)