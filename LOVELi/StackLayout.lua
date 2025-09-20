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

LOVELi.StackLayout = {}
LOVELi.StackLayout.__index = LOVELi.StackLayout
setmetatable(LOVELi.StackLayout, LOVELi.View)
function LOVELi.StackLayout:new(options) -- LOVELi.StackLayout LOVELi.StackLayout:new( { Union<"vertical", "horizontal"> orientation, int spacing, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)
	o.orientation = options.orientation or "vertical"
	o.spacing = options.spacing or 0
	return o
end
function LOVELi.StackLayout:getorientation()
	return self.orientation
end
function LOVELi.StackLayout:getspacing()
	return self.spacing
end
function LOVELi.StackLayout:with(control)
	if control.parent then
		error("Control's parent is already set.")
	end
	control.parent = self
	table.insert(self.controls, control)
	return self
end
function LOVELi.StackLayout:measure(availablewidth, availableheight) -- override
	local function measure(dimension, availabledimension)	
		--TODO: Handle invisible child
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
		if availabledimension then
			if availabledimension <= 0 or not self:getisvisible() then
				setdesireddimension(0)
				for _, control in ipairs(self:getcontrols() ) do
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
				local remaining = getdesireddimension()
				if (dimension == "width" and self:getorientation() == "horizontal") or (dimension == "height" and self:getorientation() == "vertical") then
					local proportions = 0
					local spacing = 0
					for _, control in ipairs(self:getcontrols() ) do
						if getcontroldimension(control) == "*" then
							if getdimension() == "auto" then
								error("Can not use \"*\" " .. dimension .. " control inside an \"auto\" " .. dimension .. " StackLayout.")
							end
							proportions = proportions + 1
						else
							local controldimension = getcontrolmeasure(control, remaining - spacing) + spacing
							maxdimension = maxdimension + controldimension
							remaining = remaining - controldimension
						end
						spacing = self:getspacing()
					end
					spacing = 0
					for _, control in ipairs(self:getcontrols() ) do
						if getcontroldimension(control) == "*" then
							local controldimension = getcontrolmeasure(control, remaining * 1 / proportions - spacing) + spacing
							maxdimension = maxdimension + controldimension
						end
						spacing = self:getspacing()
					end
				else
					for _, control in ipairs(self:getcontrols() ) do
						if getcontroldimension(control) == "*" and getdimension() == "auto" then
							error("Can not use \"*\" control inside an \"auto\" StackLayout.")
						end
						local controldimension = getcontrolmeasure(control, remaining)
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
function LOVELi.StackLayout:arrange(screenx, screeny, screenwidth, screenheight, viewportx, viewporty, viewportwidth, viewportheight) -- override
	self.screenx = screenx
	self.screeny = screeny
	self.screenwidth = screenwidth
	self.screenheight = screenheight
	self.viewportx = viewportx
	self.viewporty = viewporty
	self.viewportwidth = viewportwidth
	self.viewportheight = viewportheight
	local offsetx = 0
	local offsety = 0
	for _, control in ipairs(self:getcontrols() ) do
		if self:getorientation() == "horizontal" then
			local verticalalignment
			if control:getverticaloptions() == "start" then
				verticalalignment = 0
			elseif control:getverticaloptions() == "center" then
				verticalalignment = self:getdesiredheight() / 2 - (control:getdesiredheight() + control:getmargin():getvertical() ) / 2
			elseif control:getverticaloptions() == "end" then
				verticalalignment = self:getdesiredheight() - (control:getdesiredheight() + control:getmargin():getvertical() ) 
			end	
			control:arrange(
				screenx + self:getmargin():getleft() + control:getx() + offsetx,
				screeny + self:getmargin():gettop() + control:gety() + verticalalignment, 
				control:getdesiredwidth() + control:getmargin():gethorizontal(), 
				control:getdesiredheight() + control:getmargin():getvertical(),
				
				LOVELi.Math.clipx(viewportx, screenx + self:getmargin():getleft() ),
				LOVELi.Math.clipy(viewporty, screeny + self:getmargin():gettop() ),
				LOVELi.Math.clipwidth(viewportx, viewportwidth, screenx + self:getmargin():getleft(), self:getdesiredwidth() ),
				LOVELi.Math.clipheight(viewporty, viewportheight, screeny + self:getmargin():gettop(), self:getdesiredheight() )				
			)
			offsetx = offsetx + control:getdesiredwidth() + control:getmargin():gethorizontal() + self:getspacing()
		else			
			local horizontalalignment
			if control:gethorizontaloptions() == "start" then
				horizontalalignment = 0
			elseif control:gethorizontaloptions() == "center" then
				horizontalalignment = self:getdesiredwidth() / 2 - (control:getdesiredwidth() + control:getmargin():gethorizontal() ) / 2
			elseif control:gethorizontaloptions() == "end" then
				horizontalalignment = self:getdesiredwidth() - (control:getdesiredwidth() + control:getmargin():gethorizontal() )
			end	
			control:arrange(
				screenx + self:getmargin():getleft() + control:getx() + horizontalalignment,
				screeny + self:getmargin():gettop() + control:gety() + offsety, 
				control:getdesiredwidth() + control:getmargin():gethorizontal(), 
				control:getdesiredheight() + control:getmargin():getvertical(),
				
				LOVELi.Math.clipx(viewportx, screenx + self:getmargin():getleft() ),
				LOVELi.Math.clipy(viewporty, screeny + self:getmargin():gettop() ),
				LOVELi.Math.clipwidth(viewportx, viewportwidth, screenx + self:getmargin():getleft(), self:getdesiredwidth() ),
				LOVELi.Math.clipheight(viewporty, viewportheight, screeny + self:getmargin():gettop(), self:getdesiredheight() )
			)
			offsety = offsety + control:getdesiredheight() + control:getmargin():getvertical() + self:getspacing()
		end
	end	
end
function LOVELi.StackLayout:render(x, y) -- override
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
end
function LOVELi.StackLayout:type() -- override
	return "StackLayout"
end