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

LOVELi.ContentView = {}
LOVELi.ContentView.__index = LOVELi.ContentView
setmetatable(LOVELi.ContentView, LOVELi.View)
function LOVELi.ContentView:new(options) -- LOVELi.ContentView LOVELi.ContentView:new( { int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)
	o.content = nil
	return o
end
function LOVELi.ContentView:getcontrol()
	return self.content
end
function LOVELi.ContentView:with(control)
	if control.parent then
		error("Control's parent is already set.")
	end
	control.parent = self
	table.insert(self.controls, control)
	if self.content then
		error("ContentView's control is already set.")
	end
	self.content = control
	return self
end
function LOVELi.ContentView:measure(availablewidth, availableheight) -- override
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
	local control = self:getcontrol()
	if control then
		if control:getwidth() == "*" and self:getwidth() == "auto" then
			error("Can not use \"*\" width control inside an \"auto\" width ContentView.")
		end
		if control:getheight() == "*" and self:getheight() == "auto" then
			error("Can not use \"*\" height control inside an \"auto\" height ContentView.")
		end
		control:measure(math.max(0, self:getdesiredwidth() ), math.max(0, self:getdesiredheight() ) )
		if control:getisvisible() then
			desiredwidth = control:getdesiredwidth() + control:getmargin():gethorizontal()
			desiredheight = control:getdesiredheight() + control:getmargin():getvertical()
		end
	end
	if self:getwidth() == "auto" then
		self.desiredwidth = desiredwidth
	end
	if self:getheight() == "auto" then
		self.desiredheight = desiredheight
	end
end
function LOVELi.ContentView:arrange(screenx, screeny, screenwidth, screenheight, viewportx, viewporty, viewportwidth, viewportheight) -- override
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
function LOVELi.ContentView:type() -- override
	return "ContentView"
end