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
	o.content = nil
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
	return self.content
end
function LOVELi.Border:with(control)
	if control.parent then
		error("Control's parent is already set.")
	end
	control.parent = self
	table.insert(self.controls, control)
	if self.content then
		error("Border's control is already set.")
	end
	self.content = control
	return self
end
function LOVELi.Border:measure(availablewidth, availableheight) -- override
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
	local desiredwidth = self:getpadding():gethorizontal()
	local desiredheight = self:getpadding():getvertical()
	local control = self:getcontrol()
	if control then
		if control:getwidth() == "*" and self:getwidth() == "auto" then
			error("Can not use \"*\" width control inside an \"auto\" width Border.")
		end
		if control:getheight() == "*" and self:getheight() == "auto" then
			error("Can not use \"*\" height control inside an \"auto\" height Border.")
		end
		control:measure(math.max(0, self:getdesiredwidth() - self:getpadding():gethorizontal() ), math.max(0, self:getdesiredheight() - self:getpadding():getvertical() ) )
		if control:getisvisible() then
			desiredwidth = control:getdesiredwidth() + control:getmargin():gethorizontal() + self:getpadding():gethorizontal()
			desiredheight = control:getdesiredheight() + control:getmargin():getvertical() + self:getpadding():getvertical()
		end
	end
	if self:getwidth() == "auto" then
		self.desiredwidth = desiredwidth
	end
	if self:getheight() == "auto" then
		self.desiredheight = desiredheight
	end	
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
	if control then
		local horizontalalignment = 0	
		if control:gethorizontaloptions() == "start" then
			horizontalalignment = 0
		elseif control:gethorizontaloptions() == "center" then
			horizontalalignment = ( (self:getdesiredwidth() - self:getpadding():gethorizontal() ) - (control:getdesiredwidth() + control:getmargin():gethorizontal() ) ) / 2
		elseif control:gethorizontaloptions() == "end" then
			horizontalalignment = (self:getdesiredwidth() - self:getpadding():gethorizontal() ) - (control:getdesiredwidth() + control:getmargin():gethorizontal() )
		end
		local verticalalignment = 0		
		if control:getverticaloptions() == "start" then
			verticalalignment = 0
		elseif control:getverticaloptions() == "center" then
			verticalalignment = ( (self:getdesiredheight() - self:getpadding():getvertical() ) - (control:getdesiredheight() + control:getmargin():getvertical() ) ) / 2
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
	love.graphics.setColor(self:getbackgroundcolor():getrgba() )	
	love.graphics.rectangle(
		"fill", 
		x + self:getmargin():getleft(), 
		y + self:getmargin():gettop(), 
		self:getdesiredwidth(), 
		self:getdesiredheight() )
	love.graphics.setColor(self:getbordercolor():getrgba() )
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