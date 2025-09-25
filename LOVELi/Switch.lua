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

LOVELi.Switch = {}
LOVELi.Switch.__index = LOVELi.Switch
setmetatable(LOVELi.Switch, LOVELi.View)
function LOVELi.Switch:new(options) -- LOVELi.Switch LOVELi.Switch:new( { Action<LOVELi.Switch sender, bool oldvalue, bool newvalue> toggled, bool istoggled, LOVELi.Color forecolor, LOVELi.Color onbackgroundcolor, LOVELi.Color offbackgroundcolor, LOVELi.Color bordercolor, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)
	o.toggling = options.toggling
	o.toggled = options.toggled
	o.istoggled = LOVELi.Property.parse(options.istoggled or false)
	o.forecolor = LOVELi.Property.parse(options.forecolor or LOVELi.Color.parse(0xFFFFFFFF) )
	o.onbackgroundcolor = LOVELi.Property.parse(options.onbackgroundcolor or LOVELi.Color.parse(0xE6E6E6FF) )
	o.offbackgroundcolor = LOVELi.Property.parse(options.offbackgroundcolor or LOVELi.Color.parse(0xC0C0C0FF) )
	o.bordercolor = LOVELi.Property.parse(options.bordercolor or LOVELi.Color.parse(0xFFFFFFFF) )
	return o
end
function LOVELi.Switch:gettoggling()
	return self.toggling
end
function LOVELi.Switch:gettoggled()
	return self.toggled
end
function LOVELi.Switch:getistoggled()
	return self.istoggled:getvalue()
end
function LOVELi.Switch:setistoggled(value)
	self.istoggled:setvalue(value)
end
function LOVELi.Switch:getforecolor()
	return self.forecolor:getvalue()
end
function LOVELi.Switch:setforecolor(value)
	self.forecolor:setvalue(value)
end
function LOVELi.Switch:getonbackgroundcolor()
	return self.onbackgroundcolor:getvalue()
end
function LOVELi.Switch:setonbackgroundcolor(value)
	self.onbackgroundcolor:setvalue(value)
end
function LOVELi.Switch:getoffbackgroundcolor()
	return self.offbackgroundcolor:getvalue()
end
function LOVELi.Switch:setoffbackgroundcolor(value)
	self.offbackgroundcolor:setvalue(value)
end
function LOVELi.Switch:getbordercolor()
	return self.bordercolor:getvalue()
end
function LOVELi.Switch:setbordercolor(value)
	self.bordercolor:setvalue(value)
end
function LOVELi.Switch:getisfocusable() -- override
	return true
end
function LOVELi.Switch:init(layoutmanager) -- override
	if self.layoutmanager then
		error("Switch's LayoutManager is already set.")
	end
	self.layoutmanager = layoutmanager
	local function ontoggle()
		local oldvalue = self:getistoggled()
		local newvalue = not oldvalue
		if not self.toggling or self:toggling(oldvalue, newvalue) then
			self:setistoggled(newvalue)
			self:invalidate()
			if self.toggled then
				self:toggled(oldvalue, newvalue)
			end
		end
	end
	layoutmanager:subscribe("keypressed", self, function(key, scancode, isrepeat)
		if key == "space" or key == "return" or key == "kpenter" then
			ontoggle()
		end
	end)
	layoutmanager:subscribe("mousepressed", self, function(x, y, button, istouch, presses)
		ontoggle()
	end)
end
function LOVELi.Switch:measure(availablewidth, availableheight) -- override
	self.availablewidth = availablewidth
	self.availableheight = availableheight
	if self:getwidth() == "*" then
		self.desiredwidth = math.min(self:getmaxwidth(), math.max(self:getminwidth(), availablewidth - self:getmargin():gethorizontal() ) )
	elseif self:getwidth() == "auto" then
		self.desiredwidth = 40
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
function LOVELi.Switch:render(x, y) -- override
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
	if not self:getistoggled() then		
		love.graphics.setColor(self:getoffbackgroundcolor():getrgba() )
		love.graphics.rectangle(
			"fill", 
			x + self:getmargin():getleft(), 
			y + self:getmargin():gettop(), 
			self:getdesiredwidth(), 
			self:getdesiredheight() )
		love.graphics.setColor(self:getforecolor():getrgba() )
		love.graphics.rectangle(
			"fill", 
			x + self:getmargin():getleft() + (self:getdesiredwidth() / 2 * 0.1), 
			y + self:getmargin():gettop() + (self:getdesiredheight() * 0.1), 
			self:getdesiredwidth() / 2 - (self:getdesiredwidth() / 2 * 0.1), 
			self:getdesiredheight() - (self:getdesiredheight() * 0.2) )
	else
		love.graphics.setColor(self:getonbackgroundcolor():getrgba() )
		love.graphics.rectangle(
			"fill", 
			x + self:getmargin():getleft(), 
			y + self:getmargin():gettop(), 
			self:getdesiredwidth(), 
			self:getdesiredheight() )
		love.graphics.setColor(self:getforecolor():getrgba() )
		love.graphics.rectangle(
			"fill", 
			x + self:getmargin():getleft() + self:getdesiredwidth() / 2, 
			y + self:getmargin():gettop() + (self:getdesiredheight() * 0.1), 
			self:getdesiredwidth() / 2 - (self:getdesiredwidth() / 2 * 0.1), 
			self:getdesiredheight() - (self:getdesiredheight() * 0.2) )
	end	
	love.graphics.setColor(self:getbordercolor():getrgba() )
	love.graphics.rectangle(
		"line",
		x + self:getmargin():getleft() + 0.5, 
		y + self:getmargin():gettop() + 0.5,
		self:getdesiredwidth() - 1,
		self:getdesiredheight() - 1)
end
function LOVELi.Switch:type() -- override
	return "Switch"
end