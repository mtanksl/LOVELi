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
	self.availablewidth = availablewidth or self.availablewidth
	self.availableheight = availableheight or self.availableheight
	local function measure(dimension, availabledimension, auto)
		local function getdimension() if dimension == "width" then return self:getwidth() else return self:getheight() end end
		local function getmindimension() if dimension == "width" then return self:getminwidth() else return self:getminheight() end end
		local function getmaxdimension() if dimension == "width" then return self:getmaxwidth() else return self:getmaxheight() end end
		local function getdimensionmargin() if dimension == "width" then return self:getmargin():gethorizontal() else return self:getmargin():getvertical() end end
		local function setdesireddimension(value) if dimension == "width" then self.desiredwidth = value else self.desiredheight = value end end
		if availabledimension then
			if availabledimension <= 0 or not self:getisvisible() then
				setdesireddimension(0)
			elseif getdimension() == "*" then
				setdesireddimension(math.min(getmaxdimension(), math.max(getmindimension(), availabledimension - getdimensionmargin() ) ) )
			elseif getdimension() == "auto" then
				setdesireddimension(auto)
			else
				setdesireddimension(getdimension() )
			end
		end
	end
	measure("width", availablewidth, 20)
	measure("height", availableheight, 20)
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
	love.graphics.setColor(self:getbackgroundcolor():getred(), self:getbackgroundcolor():getgreen(), self:getbackgroundcolor():getblue(), self:getbackgroundcolor():getalpha() )
	love.graphics.rectangle(
		"fill", 
		x + self:getmargin():getleft(), 
		y + self:getmargin():gettop(), 
		self:getdesiredwidth(), 
		self:getdesiredheight() )	
	if self:getischecked() == false then		
	elseif self:getischecked() == true then
		love.graphics.setColor(self:getforecolor():getred(), self:getforecolor():getgreen(), self:getforecolor():getblue(), self:getforecolor():getalpha() )
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
		love.graphics.setColor(self:getforecolor():getred(), self:getforecolor():getgreen(), self:getforecolor():getblue(), self:getforecolor():getalpha() )
		love.graphics.line(
			x + self:getmargin():getleft() + (self:getdesiredwidth() * 0.2), 
			y + self:getmargin():gettop() + self:getdesiredheight() / 2, 			
			x + self:getmargin():getleft() + self:getdesiredwidth() - (self:getdesiredwidth() * 0.2), 
			y + self:getmargin():gettop() + self:getdesiredheight() / 2)
	end	
	love.graphics.setColor(self:getbordercolor():getred(), self:getbordercolor():getgreen(), self:getbordercolor():getblue(), self:getbordercolor():getalpha() )
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