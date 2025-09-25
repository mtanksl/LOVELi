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
	o.orientation = LOVELi.Property.parse(options.orientation or "vertical")
	o.spacing = LOVELi.Property.parse(options.spacing or 0)
	return o
end
function LOVELi.StackLayout:getorientation()
	return self.orientation:getvalue()
end
function LOVELi.StackLayout:setorientation(value)
	self.orientation:setvalue(value)
end
function LOVELi.StackLayout:getspacing()
	return self.spacing:getvalue()
end
function LOVELi.StackLayout:setspacing(value)
	self.spacing:setvalue(value)
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
	self.availablewidth = availablewidth
	self.availableheight = availableheight
	if self:getwidth() == "*" then
		self.desiredwidth = math.min(self:getmaxwidth(), math.max(self:getminwidth(), availablewidth - self:getmargin():gethorizontal() ) )
	elseif self:getwidth() == "auto" then
		self.desiredwidth = math.huge
	else
		self.desiredwidth = self:getwidth()
	end
	if self:getheight() == "*" then
		self.desiredheight = math.min(self:getmaxheight(), math.max(self:getminheight(), availableheight - self:getmargin():getvertical() ) )
	elseif self:getheight() == "auto" then
		self.desiredheight = math.huge
	else
		self.desiredheight = self:getheight()
	end
	local desiredwidth = 0
	local desiredheight = 0
	if self:getorientation() == "horizontal" then
		local remainingwidth = self:getdesiredwidth()
		local proportionswidth = 0
		local spacingwidth = 0		
		for _, control in ipairs(self:getcontrols() ) do
			if control:getwidth() == "*" and self:getwidth() == "auto" then
				error("Can not use \"*\" width control inside an \"auto\" width StackLayout.")
			end
			if control:getheight() == "*" and self:getheight() == "auto" then
				error("Can not use \"*\" height control inside an \"auto\" height StackLayout.")
			end
			if control:getwidth() == "*" then
				proportionswidth = proportionswidth + 1
				if control:getisvisible() then
					spacingwidth = self:getspacing()				
				end
			else
				control:measure(math.max(0, remainingwidth - spacingwidth), math.max(0, self:getdesiredheight()	) )
				if control:getisvisible() then
					local width = control:getdesiredwidth() + control:getmargin():gethorizontal() + spacingwidth
					local height = control:getdesiredheight() + control:getmargin():getvertical()
					desiredwidth = desiredwidth + width
					if height > desiredheight then
						desiredheight = height
					end
					remainingwidth = remainingwidth - width
					spacingwidth = self:getspacing()
				end
			end
		end
		spacingwidth = 0
		for _, control in ipairs(self:getcontrols() ) do
			if control:getwidth() == "*" then
				control:measure(math.max(0, remainingwidth * 1 / proportionswidth - spacingwidth), math.max(0, self:getdesiredheight()	) )
				if control:getisvisible() then
					local width = control:getdesiredwidth() + control:getmargin():gethorizontal() + spacingwidth
					local height = control:getdesiredheight() + control:getmargin():getvertical()
					desiredwidth = desiredwidth + width
					if height > desiredheight then
						desiredheight = height
					end
					spacingwidth = self:getspacing()
				end
			else
				if control:getisvisible() then
					spacingwidth = self:getspacing()				
				end
			end
		end
	else
		local remainingheight = self:getdesiredheight()	
		local proportionsheight = 0
		local spacingheight = 0
		for _, control in ipairs(self:getcontrols() ) do
			if control:getwidth() == "*" and self:getwidth() == "auto" then
				error("Can not use \"*\" width control inside an \"auto\" width StackLayout.")
			end
			if control:getheight() == "*" and self:getheight() == "auto" then
				error("Can not use \"*\" height control inside an \"auto\" height StackLayout.")
			end
			if control:getheight() == "*" then
				proportionsheight = proportionsheight + 1
				if control:getisvisible() then
					spacingheight = self:getspacing()
				end
			else			
				control:measure(math.max(0, self:getdesiredwidth() ), math.max(0, remainingheight - spacingheight) )
				if control:getisvisible() then
					local width = control:getdesiredwidth() + control:getmargin():gethorizontal()
					local height = control:getdesiredheight() + control:getmargin():getvertical() + spacingheight
					if width > desiredwidth then
						desiredwidth = width
					end
					desiredheight = desiredheight + height
					remainingheight = remainingheight - height
					spacingheight = self:getspacing()
				end
			end
		end
		spacingheight = 0
		for _, control in ipairs(self:getcontrols() ) do
			if control:getheight() == "*" then
				control:measure(math.max(0, self:getdesiredwidth() ), math.max(0, remainingheight * 1 / proportionsheight - spacingheight) )
				if control:getisvisible() then
					local width = control:getdesiredwidth() + control:getmargin():gethorizontal()
					local height = control:getdesiredheight() + control:getmargin():getvertical() + spacingheight
					if width > desiredwidth then
						desiredwidth = width
					end
					desiredheight = desiredheight + height
					spacingheight = self:getspacing()
				end
			else			
				if control:getisvisible() then
					spacingheight = self:getspacing()
				end
			end
		end
	end
	if self:getwidth() == "auto" then
		self.desiredwidth = desiredwidth
	end
	if self:getheight() == "auto" then
		self.desiredheight = desiredheight
	end
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
	if self:getorientation() == "horizontal" then
		local offsetx = 0
		for _, control in ipairs(self:getcontrols() ) do
			local verticalalignment
			if control:getverticaloptions() == "start" then
				verticalalignment = 0
			elseif control:getverticaloptions() == "center" then
				verticalalignment = ( self:getdesiredheight() - (control:getdesiredheight() + control:getmargin():getvertical() ) ) / 2
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
			if control:getisvisible() then
				offsetx = offsetx + control:getdesiredwidth() + control:getmargin():gethorizontal() + self:getspacing()
			end
		end
	else			
		local offsety = 0	
		for _, control in ipairs(self:getcontrols() ) do
			local horizontalalignment
			if control:gethorizontaloptions() == "start" then
				horizontalalignment = 0
			elseif control:gethorizontaloptions() == "center" then
				horizontalalignment = ( self:getdesiredwidth() - (control:getdesiredwidth() + control:getmargin():gethorizontal() ) ) / 2
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
			if control:getisvisible() then
				offsety = offsety + control:getdesiredheight() + control:getmargin():getvertical() + self:getspacing()
			end
		end
	end	
end
function LOVELi.StackLayout:type() -- override
	return "StackLayout"
end