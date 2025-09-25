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

LOVELi.CheckBox = {}
LOVELi.CheckBox.__index = LOVELi.CheckBox
setmetatable(LOVELi.CheckBox, LOVELi.View)
function LOVELi.CheckBox:new(options) -- LOVELi.CheckBox LOVELi.CheckBox:new( { Action<LOVELi.CheckBox sender, bool? oldvalue, bool? newvalue> checkedchanged, bool? ischecked, LOVELi.Color forecolor, LOVELi.Color backgroundcolor, LOVELi.Color bordercolor, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)
	o.checkedchanging = options.checkedchanging
	o.checkedchanged = options.checkedchanged
	o.ischecked = LOVELi.Property.parse(options.ischecked)
	o.forecolor = LOVELi.Property.parse(options.forecolor or LOVELi.Color.parse(0xFFFFFFFF) )
	o.backgroundcolor = LOVELi.Property.parse(options.backgroundcolor or LOVELi.Color.parse(0xC0C0C0FF) )
	o.bordercolor = LOVELi.Property.parse(options.bordercolor or LOVELi.Color.parse(0xFFFFFFFF) )
	return o
end
function LOVELi.CheckBox:getcheckedchanging()
	return self.checkedchanging
end
function LOVELi.CheckBox:getcheckedchanged()
	return self.checkedchanged
end
function LOVELi.CheckBox:getischecked()
	return self.ischecked:getvalue()
end
function LOVELi.CheckBox:setischecked(value)
	self.ischecked:setvalue(value)
end
function LOVELi.CheckBox:getforecolor()
	return self.forecolor:getvalue()
end
function LOVELi.CheckBox:setforecolor(value)
	self.forecolor:setvalue(value)
end
function LOVELi.CheckBox:getbackgroundcolor()
	return self.backgroundcolor:getvalue()
end
function LOVELi.CheckBox:setbackgroundcolor(value)
	self.backgroundcolor:setvalue(value)
end
function LOVELi.CheckBox:getbordercolor()
	return self.bordercolor:getvalue()
end
function LOVELi.CheckBox:setbordercolor(value)
	self.bordercolor:setvalue(value)
end
function LOVELi.CheckBox:getisfocusable() -- override
	return true
end
function LOVELi.CheckBox:init(layoutmanager) -- override
	if self.layoutmanager then
		error("CheckBox's LayoutManager is already set.")
	end
	self.layoutmanager = layoutmanager
	local function oncheckedchanged()
		local oldvalue = self:getischecked()
		local newvalue = not oldvalue
		if not self.checkedchanging or self:checkedchanging(oldvalue, newvalue) then
			self:setischecked(newvalue)
			self:invalidate()
			if self.checkedchanged then
				self:checkedchanged(oldvalue, newvalue)
			end
		end
	end
	layoutmanager:subscribe("keypressed", self, function(key, scancode, isrepeat)
		if key == "space" or key == "return" or key == "kpenter" then
			oncheckedchanged()
		end
	end)
	layoutmanager:subscribe("mousepressed", self, function(x, y, button, istouch, presses)
		oncheckedchanged()
	end)
end
function LOVELi.CheckBox:measure(availablewidth, availableheight) -- override
	self.availablewidth = availablewidth
	self.availableheight = availableheight
	if self:getwidth() == "*" then
		self.desiredwidth = math.min(self:getmaxwidth(), math.max(self:getminwidth(), availablewidth - self:getmargin():gethorizontal() ) )
	elseif self:getwidth() == "auto" then
		self.desiredwidth = 20
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
function LOVELi.CheckBox:render(x, y) -- override
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
	if self:getischecked() == false then		
	elseif self:getischecked() == true then
		love.graphics.setColor(self:getforecolor():getrgba() )
		love.graphics.line(
			x + self:getmargin():getleft() + (self:getdesiredwidth() * 0.2), 
			y + self:getmargin():gettop() + self:getdesiredheight() / 2, 			
			x + self:getmargin():getleft() + self:getdesiredwidth() / 2, 
			y + self:getmargin():gettop() - (self:getdesiredheight() * 0.2) + self:getdesiredheight() )
		love.graphics.line(
			x + self:getmargin():getleft() + self:getdesiredwidth() / 2, 
			y + self:getmargin():gettop() - (self:getdesiredheight() * 0.2) + self:getdesiredheight() , 			
			x + self:getmargin():getleft() + self:getdesiredwidth() - (self:getdesiredwidth() * 0.2), 
			y + self:getmargin():gettop() + (self:getdesiredheight() * 0.2) )
	else
		love.graphics.setColor(self:getforecolor():getrgba() )
		love.graphics.line(
			x + self:getmargin():getleft() + (self:getdesiredwidth() * 0.2), 
			y + self:getmargin():gettop() + self:getdesiredheight() / 2, 			
			x + self:getmargin():getleft() + self:getdesiredwidth() - (self:getdesiredwidth() * 0.2), 
			y + self:getmargin():gettop() + self:getdesiredheight() / 2)
	end	
	love.graphics.setColor(self:getbordercolor():getrgba() )
	love.graphics.rectangle(
		"line",
		x + self:getmargin():getleft() + 0.5, 
		y + self:getmargin():gettop() + 0.5,
		self:getdesiredwidth() - 1,
		self:getdesiredheight() - 1)
end
function LOVELi.CheckBox:type() -- override
	return "CheckBox"
end