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

LOVELi.Border = {}
LOVELi.Border.__index = LOVELi.Border
setmetatable(LOVELi.Border, LOVELi.View)
function LOVELi.Border:new(options) -- LOVELi.Border LOVELi.Border:new( { LOVELi.Thickness padding, LOVELi.Color backgroundcolor, LOVELi.Color bordercolor, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)
	o.padding = LOVELi.Property.parse(options.padding or LOVELi.Thickness.parse(0) )
	o.backgroundcolor = LOVELi.Property.parse(options.backgroundcolor or LOVELi.Color.parse(0x00000000) )
	o.bordercolor = LOVELi.Property.parse(options.bordercolor or LOVELi.Color.parse(0x00000000) )
	o.internalcontrol = nil
	return o
end
function LOVELi.Border:getpadding()
	return self.padding:getvalue()
end
function LOVELi.Border:setpadding(value)
	self.padding:setvalue(value)
end
function LOVELi.Border:getbackgroundcolor()
	return self.backgroundcolor:getvalue()
end
function LOVELi.Border:setbackgroundcolor(value)
	self.backgroundcolor:setvalue(value)
end
function LOVELi.Border:getbordercolor()
	return self.bordercolor:getvalue()
end
function LOVELi.Border:setbordercolor(value)
	self.bordercolor:setvalue(value)
end
function LOVELi.Border:getcontrol()
	return self.internalcontrol
end
function LOVELi.Border:with(control)
	if control.parent then
		error("Control's parent is already set.")
	end
	control.parent = self
	table.insert(self.controls, control)
	if self.internalcontrol then
		error("Border's control is already set.")
	end
	self.internalcontrol = control
	return self
end
function LOVELi.Border:measure(availablewidth, availableheight) -- override
	local function measure(dimension, availabledimension)	
		local function getdimension() if dimension == "width" then return self:getwidth() else return self:getheight() end end
		local function getmindimension() if dimension == "width" then return self:getminwidth() else return self:getminheight() end end
		local function getmaxdimension() if dimension == "width" then return self:getmaxwidth() else return self:getmaxheight() end end
		local function getdimensionmargin() if dimension == "width" then return self:getmargin():gethorizontal() else return self:getmargin():getvertical() end end
		local function getdimensionpadding() if dimension == "width" then return self:getpadding():gethorizontal() else return self:getpadding():getvertical() end end
		local function getdesireddimension() if dimension == "width" then return self:getdesiredwidth() else return self:getdesiredheight() end end
		local function setdesireddimension(value) if dimension == "width" then self.desiredwidth = value else self.desiredheight = value end end
		local function getcontroldimension(control) if dimension == "width" then return control:getwidth() else return control:getheight() end end
		local function getcontroldimensionmargin(control) if dimension == "width" then return control:getmargin():gethorizontal() else return control:getmargin():getvertical() end end
		local function getcontroldimensionrequest(control) if dimension == "width" then return control:getdesiredwidth() else return control:getdesiredheight() end end
		local function getcontrolmeasure(control, value) if dimension == "width" then control:measure(value, nil) else control:measure(nil, value) end return getcontroldimensionrequest(control) + getcontroldimensionmargin(control) end
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
						error("Can not use \"*\" " .. dimension .. " control inside an \"auto\" " .. dimension .. " Border.")
					end
					local controldimension = getcontrolmeasure(control, getdesireddimension() - getdimensionpadding() )
					if controldimension > 0 then
						controldimension = controldimension + getdimensionpadding()
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
function LOVELi.Border:arrange(screenx, screeny, screenwidth, screenheight, viewportx, viewporty, viewportwidth, viewportheight) -- override
	self.screenx = screenx
	self.screeny = screeny
	self.screenwidth = screenwidth
	self.screenheight = screenheight
	self.viewportx = viewportx
	self.viewporty = viewporty
	self.viewportwidth = viewportwidth
	self.viewportheight = viewportheight	
	local control = self:getcontrol()
	local horizontalalignment = 0	
	if control:gethorizontaloptions() == "start" then
		horizontalalignment = 0
	elseif control:gethorizontaloptions() == "center" then
		horizontalalignment = (self:getdesiredwidth() - self:getpadding():gethorizontal() ) / 2 - (control:getdesiredwidth() + control:getmargin():gethorizontal() ) / 2
	elseif control:gethorizontaloptions() == "end" then
		horizontalalignment = (self:getdesiredwidth() - self:getpadding():gethorizontal() ) - (control:getdesiredwidth() + control:getmargin():gethorizontal() )
	end
	local verticalalignment = 0		
	if control:getverticaloptions() == "start" then
		verticalalignment = 0
	elseif control:getverticaloptions() == "center" then
		verticalalignment = (self:getdesiredheight() - self:getpadding():getvertical() ) / 2 - (control:getdesiredheight() + control:getmargin():getvertical() ) / 2
	elseif control:getverticaloptions() == "end" then
		verticalalignment = (self:getdesiredheight() - self:getpadding():getvertical() ) - (control:getdesiredheight() + control:getmargin():getvertical() ) 
	end
	control:arrange(
		screenx + self:getmargin():getleft() + self:getpadding():getleft() + control:getx() + horizontalalignment,
		screeny + self:getmargin():gettop() + self:getpadding():gettop() + control:gety() + verticalalignment, 
		control:getdesiredwidth() + control:getmargin():gethorizontal(), 
		control:getdesiredheight() + control:getmargin():getvertical(),
		
		LOVELi.Math.clipx(viewportx, screenx + self:getmargin():getleft() + self:getpadding():getleft() ),
		LOVELi.Math.clipy(viewporty, screeny + self:getmargin():gettop() + self:getpadding():gettop() ),
		LOVELi.Math.clipwidth(viewportx, viewportwidth, screenx + self:getmargin():getleft() + self:getpadding():getleft(), self:getdesiredwidth() - self:getpadding():gethorizontal() ),
		LOVELi.Math.clipheight(viewporty, viewportheight, screeny + self:getmargin():gettop() + self:getpadding():gettop(), self:getdesiredheight() - self:getpadding():getvertical() ) 
	)
end
function LOVELi.Border:render(x, y) -- override
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
		if self:getpadding():gethorizontal() > 0 or self:getpadding():getvertical() > 0 then			
			love.graphics.setColor(0, 0, 1)
			love.graphics.rectangle(
				"line", 
				x + self:getmargin():getleft() + self:getpadding():getleft(), 
				y + self:getmargin():gettop() + self:getpadding():gettop(), 
				self:getdesiredwidth() - self:getpadding():gethorizontal(), 
				self:getdesiredheight() - self:getpadding():getvertical() )
		end
	end
	love.graphics.setColor(self:getbackgroundcolor():getred(), self:getbackgroundcolor():getgreen(), self:getbackgroundcolor():getblue(), self:getbackgroundcolor():getalpha() )	
	love.graphics.rectangle(
		"fill", 
		x + self:getmargin():getleft(), 
		y + self:getmargin():gettop(), 
		self:getdesiredwidth(), 
		self:getdesiredheight() )
	love.graphics.setColor(self:getbordercolor():getred(), self:getbordercolor():getgreen(), self:getbordercolor():getblue(), self:getbordercolor():getalpha() )
	love.graphics.rectangle(
		"line",
		x + self:getmargin():getleft() + 0.5, 
		y + self:getmargin():gettop() + 0.5,
		self:getdesiredwidth() - 1,
		self:getdesiredheight() - 1)
end
function LOVELi.Border:type() -- override
	return "Border"
end