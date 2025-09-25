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

LOVELi.AbsoluteLayout = {}
LOVELi.AbsoluteLayout.__index = LOVELi.AbsoluteLayout
setmetatable(LOVELi.AbsoluteLayout, LOVELi.View)
function LOVELi.AbsoluteLayout:new(options) -- LOVELi.AbsoluteLayout LOVELi.AbsoluteLayout:new( { int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)
	return o
end
function LOVELi.AbsoluteLayout:with(control)
	if control.parent then
		error("Control's parent is already set.")
	end
	control.parent = self
	table.insert(self.controls, control)
	return self
end
function LOVELi.AbsoluteLayout:measure(availablewidth, availableheight) -- override
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
	for _, control in ipairs(self:getcontrols() ) do
		if control:getwidth() == "*" and self:getwidth() == "auto" then
			error("Can not use \"*\" width control inside an \"auto\" width AbsoluteLayout.")
		end
		if control:getheight() == "*" and self:getheight() == "auto" then
			error("Can not use \"*\" height control inside an \"auto\" height AbsoluteLayout.")
		end
		control:measure(math.max(0, self:getdesiredwidth() - control:getx() ), math.max(0, self:getdesiredheight() - control:gety() ) )
		if control:getisvisible() then
			local width = control:getdesiredwidth() + control:getmargin():gethorizontal() + control:getx()
			local height = control:getdesiredheight() + control:getmargin():getvertical() + control:gety()
			if width > desiredwidth then
				desiredwidth = width
			end			
			if height > desiredheight then
				desiredheight = height
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
function LOVELi.AbsoluteLayout:arrange(screenx, screeny, screenwidth, screenheight, viewportx, viewporty, viewportwidth, viewportheight) -- override
	self.screenx = screenx
	self.screeny = screeny
	self.screenwidth = screenwidth
	self.screenheight = screenheight
	self.viewportx = viewportx
	self.viewporty = viewporty
	self.viewportwidth = viewportwidth
	self.viewportheight = viewportheight
	for _, control in ipairs(self:getcontrols() ) do
		local horizontalalignment = 0	
		if control:gethorizontaloptions() == "start" then
			horizontalalignment = 0
		elseif control:gethorizontaloptions() == "center" then
			horizontalalignment = ( self:getdesiredwidth() - (control:getdesiredwidth() + control:getmargin():gethorizontal() ) ) / 2
		elseif control:gethorizontaloptions() == "end" then
			horizontalalignment = self:getdesiredwidth() - (control:getdesiredwidth() + control:getmargin():gethorizontal() )
		end
		local verticalalignment = 0		
		if control:getverticaloptions() == "start" then
			verticalalignment = 0
		elseif control:getverticaloptions() == "center" then
			verticalalignment = ( self:getdesiredheight() - (control:getdesiredheight() + control:getmargin():getvertical() ) ) / 2
		elseif control:getverticaloptions() == "end" then
			verticalalignment = self:getdesiredheight() - (control:getdesiredheight() + control:getmargin():getvertical() ) 
		end
		control:arrange(
			screenx + self:getmargin():getleft() + control:getx() + horizontalalignment,
			screeny + self:getmargin():gettop() + control:gety() + verticalalignment, 
			control:getdesiredwidth() + control:getmargin():gethorizontal(), 
			control:getdesiredheight() + control:getmargin():getvertical(),
			
			LOVELi.Math.clipx(viewportx, screenx + self:getmargin():getleft() ),
			LOVELi.Math.clipy(viewporty, screeny + self:getmargin():gettop() ),
			LOVELi.Math.clipwidth(viewportx, viewportwidth, screenx + self:getmargin():getleft(), self:getdesiredwidth() ),
			LOVELi.Math.clipheight(viewporty, viewportheight, screeny + self:getmargin():gettop(), self:getdesiredheight() )
		)
	end
end
function LOVELi.AbsoluteLayout:type() -- override
	return "AbsoluteLayout"
end