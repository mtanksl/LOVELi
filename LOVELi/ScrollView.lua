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

LOVELi.ScrollView = {}
LOVELi.ScrollView.__index = LOVELi.ScrollView
setmetatable(LOVELi.ScrollView, LOVELi.View)
function LOVELi.ScrollView:new(options) -- LOVELi.ScrollView LOVELi.ScrollView:new( { Action<LOVELi.ScrollView sender, int dx, int dy> scrolled, Union<"vertical", "horizontal", "both", "neither"> orientation, Union<"default", "always", "never"> horizontalscrollbarvisibility, int horizontalscrollbarheight, Union<"default", "always", "never"> verticalscrollbarvisibility, int verticalscrollbarwidth, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)
	o.scrolled = options.scrolled
	o.orientation = LOVELi.Property.parse(options.orientation or "vertical")
	o.horizontalscrollbarvisibility = LOVELi.Property.parse(options.horizontalscrollbarvisibility or "default")
	o.horizontalscrollbarheight = LOVELi.Property.parse(options.horizontalscrollbarheight or 5)
	o.horizontalscrollbarincrement = LOVELi.Property.parse(options.horizontalscrollbarincrement or 100)
	o.verticalscrollbarvisibility = LOVELi.Property.parse(options.verticalscrollbarvisibility or "default")
	o.verticalscrollbarwidth = LOVELi.Property.parse(options.verticalscrollbarwidth or 5)
	o.verticalscrollbarincrement = LOVELi.Property.parse(options.verticalscrollbarincrement or 100)	
	o.scrollx = LOVELi.Property.parse(options.scrollx or 0)
	o.scrolly = LOVELi.Property.parse(options.scrolly or 0)
	o.content = nil
	return o
end
function LOVELi.ScrollView:getscrolled()
	return self.scrolled
end
function LOVELi.ScrollView:getorientation()
	return self.orientation:getvalue()
end
function LOVELi.ScrollView:setorientation(value)
	self.orientation:setvalue(value)
end
function LOVELi.ScrollView:gethorizontalscrollbarvisibility()
	return self.horizontalscrollbarvisibility:getvalue()
end
function LOVELi.ScrollView:sethorizontalscrollbarvisibility(value)
	self.horizontalscrollbarvisibility:setvalue(value)
end
function LOVELi.ScrollView:gethorizontalscrollbarheight()
	return self.horizontalscrollbarheight:getvalue()
end
function LOVELi.ScrollView:sethorizontalscrollbarheight(value)
	self.horizontalscrollbarheight:setvalue(value)
end
function LOVELi.ScrollView:gethorizontalscrollbarincrement()
	return self.horizontalscrollbarincrement:getvalue()
end
function LOVELi.ScrollView:sethorizontalscrollbarincrement(value)
	self.horizontalscrollbarincrement:setvalue(value)
end
function LOVELi.ScrollView:getverticalscrollbarvisibility()
	return self.verticalscrollbarvisibility:getvalue()
end
function LOVELi.ScrollView:setverticalscrollbarvisibility(value)
	self.verticalscrollbarvisibility:setvalue(value)
end
function LOVELi.ScrollView:getverticalscrollbarwidth()
	return self.verticalscrollbarwidth:getvalue()
end
function LOVELi.ScrollView:setverticalscrollbarwidth(value)
	self.verticalscrollbarwidth:setvalue(value)
end
function LOVELi.ScrollView:getverticalscrollbarincrement()
	return self.verticalscrollbarincrement:getvalue()
end
function LOVELi.ScrollView:setverticalscrollbarincrement(value)
	self.verticalscrollbarincrement:setvalue(value)
end
function LOVELi.ScrollView:getscrollx()
	return self.scrollx:getvalue()
end
function LOVELi.ScrollView:setscrollx(value)
	self.scrollx:setvalue(value)
end
function LOVELi.ScrollView:getscrolly()
	return self.scrolly:getvalue()
end
function LOVELi.ScrollView:setscrolly(value)
	self.scrolly:setvalue(value)
end
function LOVELi.ScrollView:getcontrol()
	return self.content
end
function LOVELi.ScrollView:with(control)
	if control.parent then
		error("Control's parent is already set.")
	end
	control.parent = self
	table.insert(self.controls, control)
	if self.content then
		error("ScrollView's control is already set.")
	end
	self.content = control
	return self
end
function LOVELi.ScrollView:init(layoutmanager) -- override
	if self.layoutmanager then
		error("ScrollView's LayoutManager is already set.")
	end
	self.layoutmanager = layoutmanager
	local function onscrolled(dx, dy)
		if self.scrolled then
			self:scrolled(dx, dy)
		end
	end
	layoutmanager:subscribe("wheelmoved", self, function(x, y, dx, dy)
		local control = self:getcontrol()
		if control then		
			if dy < 0 then -- scrolling down
				if self:getorientation() == "vertical" or self:getorientation() == "both" then					
					local scrollbarheight = self:getdesiredheight() - self:gethorizontalscrollbarheight()
					local controlheight = control:getdesiredheight() + control:getmargin():getvertical()
					local diff = controlheight - scrollbarheight
					if diff > 0 then
						local oldvalue = self:getscrolly()
						local newvalue = math.max(-diff, oldvalue - self:getverticalscrollbarincrement() )
						if oldvalue ~= newvalue then
							onscrolled(newvalue - oldvalue, 0) 
							self:setscrolly(newvalue)
							self:invalidatearrange()
							self:invalidate()
						end
					end
				end
			elseif dx > 0 then -- scrolling left
				if self:getorientation() == "horizontal" or self:getorientation() == "both" then					
					local scrollbarwidth = self:getdesiredwidth() - self:getverticalscrollbarwidth()
					local controlwidth = control:getdesiredwidth() + control:getmargin():gethorizontal()
					local diff = controlwidth - scrollbarwidth
					if diff > 0 then
						local oldvalue = self:getscrollx()
						local newvalue = math.min(0, oldvalue + self:gethorizontalscrollbarincrement() )
						if oldvalue ~= newvalue then
							onscrolled(0, newvalue - oldvalue) 
							self:setscrollx(newvalue)
							self:invalidatearrange()
							self:invalidate()
						end
					end
				end
			elseif dx < 0 then -- scrolling right
				if self:getorientation() == "horizontal" or self:getorientation() == "both" then
					local scrollbarwidth = self:getdesiredwidth() - self:getverticalscrollbarwidth()
					local controlwidth = control:getdesiredwidth() + control:getmargin():gethorizontal()
					local diff = controlwidth - scrollbarwidth
					if diff > 0 then
						local oldvalue = self:getscrollx()
						local newvalue = math.max(-diff, oldvalue - self:gethorizontalscrollbarincrement() )
						if oldvalue ~= newvalue then
							onscrolled(0, newvalue - oldvalue) 
							self:setscrollx(newvalue)
							self:invalidatearrange()
							self:invalidate()
						end
					end
				end
			elseif dy > 0 then -- scrolling up
				if self:getorientation() == "vertical" or self:getorientation() == "both" then					
					local scrollbarheight = self:getdesiredheight() - self:gethorizontalscrollbarheight()
					local controlheight = control:getdesiredheight() + control:getmargin():getvertical()
					local diff = controlheight - scrollbarheight
					if diff > 0 then
						local oldvalue = self:getscrolly()
						local newvalue = math.min(0, oldvalue + self:getverticalscrollbarincrement() )
						if oldvalue ~= newvalue then
							onscrolled(newvalue - oldvalue, 0) 
							self:setscrolly(newvalue)
							self:invalidatearrange()
							self:invalidate()
						end
					end
				end
			end			
		end
	end)
end
function LOVELi.ScrollView:measure(availablewidth, availableheight) -- override
	self.availablewidth = availablewidth or self.availablewidth
	self.availableheight = availableheight or self.availableheight
	local function measure(dimension, availabledimension)	
		local function getdimension() if dimension == "width" then return self:getwidth() else return self:getheight() end end
		local function getmindimension() if dimension == "width" then return self:getminwidth() else return self:getminheight() end end
		local function getmaxdimension() if dimension == "width" then return self:getmaxwidth() else return self:getmaxheight() end end
		local function getdimensionmargin() if dimension == "width" then return self:getmargin():gethorizontal() else return self:getmargin():getvertical() end end
		local function getdesireddimension() if dimension == "width" then return self:getdesiredwidth() else return self:getdesiredheight() end end
		local function setdesireddimension(value) if dimension == "width" then self.desiredwidth = value else self.desiredheight = value end end
		local function getcontroldimension(control) if dimension == "width" then return control:getwidth() else return control:getheight() end end
		local function getcontroldimensionmargin(control) if dimension == "width" then return control:getmargin():gethorizontal() else return control:getmargin():getvertical() end end
		local function getcontroldimensionrequest(control) if dimension == "width" then return control:getdesiredwidth() else return control:getdesiredheight() end end
		local function getcontrolmeasure(control, value) if dimension == "width" then control:measure(value, nil) else control:measure(nil, value) end return getcontroldimensionrequest(control) + getcontroldimensionmargin(control) end
		local function getscrollbardimension() if dimension == "width" then return self:getverticalscrollbarwidth() else return self:gethorizontalscrollbarheight() end end
		if availabledimension then
			if availabledimension <= 0 or not self:getisvisible() then
				setdesireddimension(0)
				local control = self:getcontrol()
				if control then
					getcontrolmeasure(control, 0)
				end
			else
				if getdimension() == "*" then
					setdesireddimension(math.min(getmaxdimension(), math.max(getmindimension(), availabledimension - getdimensionmargin() ) ) )
				elseif getdimension() == "auto" then
					setdesireddimension(availabledimension - getdimensionmargin() )
				else
					setdesireddimension(getdimension() )
				end
				local maxdimension = 0
				local control = self:getcontrol()
				if control then
					if getcontroldimension(control) == "*" and getdimension() == "auto" then
						error("Can not use \"*\" " .. dimension .. " control inside an \"auto\" " .. dimension .. " ScrollView.")
					end					
					local controldimension
					if getcontroldimension(control) == "*" then
						controldimension = getcontrolmeasure(control, getdesireddimension() - getscrollbardimension() ) 
					else
						controldimension = getcontrolmeasure(control, math.huge) 
					end
					if controldimension > 0 then
						controldimension = controldimension + getscrollbardimension()
						if controldimension > maxdimension then
							maxdimension = controldimension
						end
					end
				end
				if getdimension() == "auto" then
					setdesireddimension(maxdimension)
				end
			end
		end
	end
	measure("width", availablewidth)
	measure("height", availableheight)
end
function LOVELi.ScrollView:arrange(screenx, screeny, screenwidth, screenheight, viewportx, viewporty, viewportwidth, viewportheight) -- override
	self.screenx = screenx
	self.screeny = screeny
	self.screenwidth = screenwidth
	self.screenheight = screenheight
	self.viewportx = viewportx
	self.viewporty = viewporty
	self.viewportwidth = viewportwidth
	self.viewportheight = viewportheight	
	local control = self:getcontrol()
	if control then
		local horizontalalignment = 0	
		if control:gethorizontaloptions() == "start" then
			horizontalalignment = 0
		elseif control:gethorizontaloptions() == "center" then
			horizontalalignment = (self:getdesiredwidth() - self:getverticalscrollbarwidth() ) / 2 - (control:getdesiredwidth() + control:getmargin():gethorizontal() ) / 2
		elseif control:gethorizontaloptions() == "end" then
			horizontalalignment = (self:getdesiredwidth() - self:getverticalscrollbarwidth() ) - (control:getdesiredwidth() + control:getmargin():gethorizontal() )
		end
		local verticalalignment = 0		
		if control:getverticaloptions() == "start" then
			verticalalignment = 0
		elseif control:getverticaloptions() == "center" then
			verticalalignment = (self:getdesiredheight() - self:gethorizontalscrollbarheight() ) / 2 - (control:getdesiredheight() + control:getmargin():getvertical() ) / 2
		elseif control:getverticaloptions() == "end" then
			verticalalignment = (self:getdesiredheight() - self:gethorizontalscrollbarheight() ) - (control:getdesiredheight() + control:getmargin():getvertical() ) 
		end
		control:arrange(
			screenx + self:getmargin():getleft() + control:getx() + horizontalalignment + self:getscrollx(),
			screeny + self:getmargin():gettop() + control:gety() + verticalalignment + self:getscrolly(), 
			control:getdesiredwidth() + control:getmargin():gethorizontal(), 
			control:getdesiredheight() + control:getmargin():getvertical(),
			
			LOVELi.Math.clipx(viewportx, screenx + self:getmargin():getleft() ),
			LOVELi.Math.clipy(viewporty, screeny + self:getmargin():gettop() ),
			LOVELi.Math.clipwidth(viewportx, viewportwidth, screenx + self:getmargin():getleft(), self:getdesiredwidth() - self:getverticalscrollbarwidth() ),
			LOVELi.Math.clipheight(viewporty, viewportheight, screeny + self:getmargin():gettop(), self:getdesiredheight() - self:gethorizontalscrollbarheight() ) 
		)
	end
end
function LOVELi.ScrollView:render(x, y) -- override
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
	local control = self:getcontrol()
	if control then
		local scrollbarwidth = self:getdesiredwidth() - self:getverticalscrollbarwidth()
		local controlwidth = control:getdesiredwidth() + control:getmargin():gethorizontal()
		if (self:gethorizontalscrollbarvisibility() == "default" or self:gethorizontalscrollbarvisibility() == "always") and controlwidth > scrollbarwidth then
			local proportion = scrollbarwidth / controlwidth
			local thumbsize = scrollbarwidth * proportion
			love.graphics.setColor(0.5, 0.5, 0.5, 1)
			love.graphics.rectangle(
				"fill", 
				x + self:getmargin():getleft() - self:getscrollx() * proportion, 
				y + self:getmargin():gettop() + self:getdesiredheight() - self:gethorizontalscrollbarheight(), 
				thumbsize,
				self:gethorizontalscrollbarheight() )
		elseif self:gethorizontalscrollbarvisibility() == "always" then
			love.graphics.setColor(0.5, 0.5, 0.5, 1)
			love.graphics.rectangle(
				"fill", 
				x + self:getmargin():getleft(), 
				y + self:getmargin():gettop() + self:getdesiredheight() - self:gethorizontalscrollbarheight(), 
				scrollbarwidth,
				self:gethorizontalscrollbarheight() )
		end
		local scrollbarheight = self:getdesiredheight() - self:gethorizontalscrollbarheight()
		local controlheight = control:getdesiredheight() + control:getmargin():getvertical()
		if (self:getverticalscrollbarvisibility() == "default" or self:getverticalscrollbarvisibility() == "always") and controlheight > scrollbarheight then
			local proportion = scrollbarheight / controlheight
			local thumbsize = proportion * scrollbarheight
			love.graphics.setColor(0.5, 0.5, 0.5, 1)
			love.graphics.rectangle(
				"fill", 
				x + self:getmargin():getleft() + self:getdesiredwidth() - self:getverticalscrollbarwidth(), 
				y + self:getmargin():gettop() - self:getscrolly() * proportion, 				
				self:getverticalscrollbarwidth(),
				thumbsize)
		elseif self:getverticalscrollbarvisibility() == "always" then
			love.graphics.setColor(0.5, 0.5, 0.5, 1)
			love.graphics.rectangle(
				"fill", 
				x + self:getmargin():getleft() + self:getdesiredwidth() - self:getverticalscrollbarwidth(), 
				y + self:getmargin():gettop(), 				
				self:getverticalscrollbarwidth(),
				scrollbarheight)
		end
	end
end
function LOVELi.ScrollView:type() -- override
	return "ScrollView"
end