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

LOVELi.Slider = {}
LOVELi.Slider.__index = LOVELi.Slider
setmetatable(LOVELi.Slider, LOVELi.View)
function LOVELi.Slider:new(options) -- LOVELi.Slider LOVELi.Slider:new( { Action<LOVELi.Slider sender, int oldvalue, int newvalue> valuechanged, int value, int minimum, int maximum, LOVELi.Color forecolor, LOVELi.Color backgroundcolor, LOVELi.Color bordercolor, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)
	o.valuechanging = options.valuechanging
	o.valuechanged = options.valuechanged
	o.value = LOVELi.Property.parse(options.value or 0)
	o.minimum = LOVELi.Property.parse(options.minimum or 0)
	o.maximum = LOVELi.Property.parse(options.maximum or 10)
	o.forecolor = LOVELi.Property.parse(options.forecolor or LOVELi.Color.parse(0xFFFFFFFF) )
	o.backgroundcolor = LOVELi.Property.parse(options.backgroundcolor or LOVELi.Color.parse(0xC0C0C0FF) )
	o.bordercolor = LOVELi.Property.parse(options.bordercolor or LOVELi.Color.parse(0xFFFFFFFF) )
	return o
end
function LOVELi.Slider:getvaluechanging()
	return self.valuechanging
end
function LOVELi.Slider:getvaluechanged()
	return self.valuechanged
end
function LOVELi.Slider:getvalue()
	return self.value:getvalue()
end
function LOVELi.Slider:setvalue(value)
	self.value:setvalue(value)
end
function LOVELi.Slider:getminimum()
	return self.minimum:getvalue()
end
function LOVELi.Slider:setminimum(set)
	self.minimum:setvalue(value)
end
function LOVELi.Slider:getmaximum()
	return self.maximum:getvalue()
end
function LOVELi.Slider:setmaximum(value)
	self.maximum:setvalue(value)
end
function LOVELi.Slider:getforecolor()
	return self.forecolor:getvalue()
end
function LOVELi.Slider:setforecolor(value)
	self.forecolor:setvalue(value)
end
function LOVELi.Slider:getbackgroundcolor()
	return self.backgroundcolor:getvalue()
end
function LOVELi.Slider:setbackgroundcolor(value)
	self.backgroundcolor:setvalue(value)
end
function LOVELi.Slider:getbordercolor()
	return self.bordercolor:getvalue()
end
function LOVELi.Slider:setbordercolor(value)
	self.bordercolor:setvalue(value)
end
function LOVELi.Slider:getisfocusable() -- override
	return true
end
function LOVELi.Slider:init(layoutmanager) -- override
	if self.layoutmanager then
		error("Slider's LayoutManager is already set.")
	end
	self.layoutmanager = layoutmanager
	local function onvaluechange(oldvalue, newvalue)
		if not self.valuechanging or self:valuechanging(oldvalue, newvalue) then
			self:setvalue(newvalue)
			self:invalidate()
			if self.valuechanged then
				self:valuechanged(oldvalue, newvalue)
			end
		end
	end
	layoutmanager:subscribe("keypressed", self, function(key, scancode, isrepeat)
		if key == "left" then
			local oldvalue = self:getvalue()
			local newvalue = oldvalue - 1
			if newvalue >= self:getminimum() then
				onvaluechange(oldvalue, newvalue)
			end
		elseif key == "right" then
			local oldvalue = self:getvalue()
			local newvalue = oldvalue + 1
			if newvalue <= self:getmaximum() then
				onvaluechange(oldvalue, newvalue)
			end
		end
	end)
	local pressed = false
	layoutmanager:subscribe("mousepressed", self, function(x, y, button, istouch, presses)
		pressed = true			
		local thumbsize = self:getdesiredwidth() / (self:getmaximum() - self:getminimum() + 1)
		local oldvalue = self:getvalue()		
		local newvalue = math.min(self:getmaximum(), math.max(self:getminimum(), math.floor( (x - (self:getscreenx() + self:getmargin():getleft() ) ) / thumbsize) ) )
		if oldvalue ~= newvalue then
			onvaluechange(oldvalue, newvalue)
		end
	end)
	layoutmanager:subscribe("mousemoved", self, function(x, y, dx, dy, istouch)
		if pressed then
			local thumbsize = self:getdesiredwidth() / (self:getmaximum() - self:getminimum() + 1)
			local oldvalue = self:getvalue()
			local newvalue = math.min(self:getmaximum(), math.max(self:getminimum(), math.floor( (x - (self:getscreenx() + self:getmargin():getleft() ) ) / thumbsize) ) )
			if oldvalue ~= newvalue then
				onvaluechange(oldvalue, newvalue)
			end
		end
	end)
	layoutmanager:subscribe("mousereleased", self, function(x, y, button, istouch, presses)
		if pressed then
			pressed = false
		end
	end)
	layoutmanager:subscribe("wheelmoved", self, function(x, y, dx, dy)
		if dy < 0 then -- scrolling down
			local oldvalue = self:getvalue()
			local newvalue = oldvalue + 1
			if newvalue <= self:getmaximum() then
				onvaluechange(oldvalue, newvalue)
			end
		elseif dy > 0 then -- scrolling up
			local oldvalue = self:getvalue()
			local newvalue = oldvalue - 1
			if newvalue >= self:getminimum() then
				onvaluechange(oldvalue, newvalue)
			end		
		end
	end)
end
function LOVELi.Slider:measure(availablewidth, availableheight) -- override
	self.availablewidth = availablewidth
	self.availableheight = availableheight
	if self:getwidth() == "*" then
		self.desiredwidth = math.min(self:getmaxwidth(), math.max(self:getminwidth(), availablewidth - self:getmargin():gethorizontal() ) )
	elseif self:getwidth() == "auto" then
		self.desiredwidth = 100
	else
		self.desiredwidth = self:getwidth()
	end
	if self:getheight() == "*" then
		self.desiredheight = math.min(self:getmaxheight(), math.max(self:getminheight(), availableheight - self:getmargin():getvertical() ) )
	elseif self:getheight() == "auto" then
		self.desiredheight = 20
	else
		self.desiredheight = self:getheight()
	end
end
function LOVELi.Slider:render(x, y) -- override
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
	love.graphics.setColor(self:getbackgroundcolor():getrgba() )
	love.graphics.rectangle(
		"fill", 
		x + self:getmargin():getleft(), 
		y + self:getmargin():gettop(), 
		self:getdesiredwidth(), 
		self:getdesiredheight() )
	love.graphics.setColor(self:getforecolor():getrgba() )
	local thumbsize = self:getdesiredwidth() / (self:getmaximum() - self:getminimum() + 1)
	love.graphics.rectangle(
		"fill", 
		x + self:getmargin():getleft() + self:getvalue() * thumbsize, 
		y + self:getmargin():gettop(), 
		thumbsize, 
		self:getdesiredheight() )
	love.graphics.setColor(self:getbordercolor():getrgba() )
	love.graphics.rectangle(
		"line",
		x + self:getmargin():getleft() + 0.5, 
		y + self:getmargin():gettop() + 0.5,
		self:getdesiredwidth() - 1,
		self:getdesiredheight() - 1)
end
function LOVELi.Slider:type() -- override
	return "Slider"
end