-- MIT License
-- 
-- Copyright (c) 2025 mtanksl
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell		
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

LOVELi.Image = {}
LOVELi.Image.__index = LOVELi.Image
setmetatable(LOVELi.Image, LOVELi.View)
function LOVELi.Image:new(options) -- LOVELi.Image LOVELi.Image:new( { string source, Union<"aspectfit", "aspectfill", "fill"> aspect, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)
	o.image = LOVELi.Property.parse(love.graphics.newImage(options.source) )
	o.aspect = LOVELi.Property.parse(options.aspect or "aspectfit")
	return o
end
function LOVELi.Image:getimage()
	return self.image:getvalue()
end
function LOVELi.Image:setimage(value)
	self.image:setvalue(value)
end
function LOVELi.Image:getaspect()
	return self.aspect:getvalue()
end
function LOVELi.Image:setaspect(value)
	self.aspect:setvalue(value)
end
function LOVELi.Image:measure(availablewidth, availableheight) -- override
	local function measure(dimension, availabledimension)
		local function getdimension() if dimension == "width" then return self:getwidth() else return self:getheight() end end
		local function getmindimension() if dimension == "width" then return self:getminwidth() else return self:getminheight() end end
		local function getmaxdimension() if dimension == "width" then return self:getmaxwidth() else return self:getmaxheight() end end
		local function getdimensionmargin() if dimension == "width" then return self:getmargin():gethorizontal() else return self:getmargin():getvertical() end end
		local function setdesireddimension(value) if dimension == "width" then self.desiredwidth = value else self.desiredheight = value end end
		local function getimagedimension() if dimension == "width" then return self:getimage():getWidth() else return self:getimage():getHeight() end end
		if availabledimension then
			if availabledimension <= 0 or not self:getisvisible() then
				setdesireddimension(0)
			elseif getdimension() == "*" then
				setdesireddimension(math.min(getmaxdimension(), math.max(getmindimension(), availabledimension - getdimensionmargin() ) ) )
			elseif getdimension() == "auto" then
				setdesireddimension(getimagedimension() )
			else
				setdesireddimension(getdimension() )
			end
		end
	end
	measure("width", availablewidth)
	measure("height", availableheight)
end
function LOVELi.Image:render(x, y) -- override
	if self:getlayoutmanager():getshowlayoutlines() then
		if self:getmargin():gethorizontal() > 0 or self:getmargin():getvertical() > 0 then
			love.graphics.setColor(1, 1, 0)
			love.graphics.rectangle(
				"line", 
				x, 
				y, 
				self:getdesiredwidth() + self:getmargin():gethorizontal(),  
				self:getdesiredheight() + self:getmargin():getvertical() )
		end
		love.graphics.setColor(1, 1, 1)
		love.graphics.rectangle(
			"line", 
			x + self:getmargin():getleft(), 
			y + self:getmargin():gettop(), 
			self:getdesiredwidth(), 
			self:getdesiredheight() )
	end
	local image = self:getimage()
	local aspect = self:getaspect()
	local width = self:getdesiredwidth()
	local height = self:getdesiredheight()
	local imagewidth = image:getWidth()
	local imageheight = image:getHeight()
	local scalex = width / imagewidth
	local scaley = height / imageheight
	if aspect == "aspectfit" then
		-- Scales the image to fit within the bounds of the view while maintaining its aspect ratio
		local scale = (width / height) < (imagewidth / imageheight) and scalex or scaley
		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(
			image,
			x + self:getmargin():getleft() + width / 2 - imagewidth * scale / 2,
			y + self:getmargin():gettop() + height / 2 - imageheight * scale / 2,
			0,
			scale,
			scale)
	elseif aspect == "aspectfill" then
		-- Scales the image to fill the bounds of the view while maintaining its aspect ratio
		local scale = math.max(scalex, scaley)
		love.graphics.setScissor(
			x + self:getmargin():getleft(),
			y + self:getmargin():gettop(),
			width,
			height)
		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(
			image,
			x + self:getmargin():getleft(),
			y + self:getmargin():gettop(),
			0,
			scale,
			scale)
		love.graphics.setScissor()
	elseif aspect == "fill" then
		-- Stretches the image to completely fill the bounds of the view, disregarding the aspect ratio
		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(
			image,
			x + self:getmargin():getleft(),
			y + self:getmargin():gettop(),
			0,
			scalex,
			scaley)
	end
end
function LOVELi.Image:type() -- override
	return "Image"
end