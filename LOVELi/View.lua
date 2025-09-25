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

LOVELi.View = {}
LOVELi.View.__index = LOVELi.View
function LOVELi.View:new(options) -- LOVELi.View LOVELi.View:new( { int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = {
		x = LOVELi.Property.parse(options.x or 0),
		y = LOVELi.Property.parse(options.y or 0),
		width = LOVELi.Property.parse(options.width or "auto"),
		height = LOVELi.Property.parse(options.height or "auto"),
		minwidth = LOVELi.Property.parse(options.minwidth or 0),
		maxwidth = LOVELi.Property.parse(options.maxwidth or math.huge),
		minheight = LOVELi.Property.parse(options.minheight or 0),
		maxheight = LOVELi.Property.parse(options.maxheight or math.huge),
		margin = LOVELi.Property.parse(options.margin or LOVELi.Thickness.parse(0) ),
		horizontaloptions = LOVELi.Property.parse(options.horizontaloptions or "start"),
		verticaloptions = LOVELi.Property.parse(options.verticaloptions or "start"),		
		name = LOVELi.Property.parse(options.name),
		layoutmanager = nil,
		parent = nil,
		controls = {},
		availablewidth = nil,
		availableheight = nil,		
		desiredwidth = nil,
		desiredheight = nil,
		screenx = nil,
		screeny = nil,
		screenwidth = nil,
		screenheight = nil,
		viewportx = nil,		
		viewporty = nil,
		viewportwidth = nil,
		viewportheight = nil,
		canvas = nil,
		invalid = true -- private
	}	
	if options.isvisible == nil then
		o.isvisible = LOVELi.Property.parse(true)
	else
		o.isvisible = LOVELi.Property.parse(options.isvisible)
	end
	if options.isenabled == nil then
		o.isenabled = LOVELi.Property.parse(true)
	else
		o.isenabled = LOVELi.Property.parse(options.isenabled)
	end
	setmetatable(o, self)
	return o
end
function LOVELi.View:getx()
	return self.x:getvalue()
end
function LOVELi.View:setx(value)
	self.x:setvalue(value)
end
function LOVELi.View:gety()
	return self.y:getvalue()
end
function LOVELi.View:sety(value)
	self.y:setvalue(value)
end
function LOVELi.View:getwidth()
	return self.width:getvalue()
end
function LOVELi.View:setwidth(value)
	self.width:setvalue(value)
end
function LOVELi.View:getheight()
	return self.height:getvalue()
end
function LOVELi.View:setheight(value)
	self.height:setvalue(value)
end
function LOVELi.View:getminwidth()
	return self.minwidth:getvalue()
end
function LOVELi.View:setminwidth(value)
	self.minwidth:setvalue(value)
end
function LOVELi.View:getmaxwidth()
	return self.maxwidth:getvalue()
end
function LOVELi.View:setmaxwidth(value)
	self.maxwidth:setvalue(value)
end
function LOVELi.View:getminheight()
	return self.minheight:getvalue()
end
function LOVELi.View:setminheight(value)
	self.minheight:setvalue(value)
end
function LOVELi.View:getmaxheight()
	return self.maxheight:getvalue()
end
function LOVELi.View:setmaxheight(value)
	self.maxheight:setvalue(value)
end
function LOVELi.View:getmargin()
	return self.margin:getvalue()
end
function LOVELi.View:setmargin(value)
	self.margin:setvalue(value)
end
function LOVELi.View:gethorizontaloptions()
	return self.horizontaloptions:getvalue()
end
function LOVELi.View:sethorizontaloptions(value)
	self.horizontaloptions:setvalue(value)
end
function LOVELi.View:getverticaloptions()
	return self.verticaloptions:getvalue()
end
function LOVELi.View:setverticaloptions(value)
	self.verticaloptions:setvalue(value)
end
function LOVELi.View:getname()
	return self.name:getvalue()
end
function LOVELi.View:setname(value)
	self.name:setvalue(value)
end
function LOVELi.View:getisvisible()
	return self.isvisible:getvalue()
end
function LOVELi.View:setisvisible(value)
	self.isvisible:setvalue(value)
end
function LOVELi.View:getisenabled()
	return self.isenabled:getvalue()
end
function LOVELi.View:setisenabled(value)
	self.isenabled:setvalue(value)
end
function LOVELi.View:getlayoutmanager()
	return self.layoutmanager
end
function LOVELi.View:getparent()
	return self.parent
end
function LOVELi.View:getcontrols()
	return self.controls
end
function LOVELi.View:getavailablewidth()
	return self.availablewidth
end
function LOVELi.View:getavailableheight()
	return self.availableheight
end
function LOVELi.View:getdesiredwidth()
	return self.desiredwidth
end
function LOVELi.View:getdesiredheight()
	return self.desiredheight
end
function LOVELi.View:getscreenx()
	return self.screenx
end
function LOVELi.View:getscreeny()
	return self.screeny
end
function LOVELi.View:getscreenwidth()
	return self.screenwidth
end
function LOVELi.View:getscreenheight()
	return self.screenheight
end
function LOVELi.View:getviewportx()
	return self.viewportx
end
function LOVELi.View:getviewporty()
	return self.viewporty
end
function LOVELi.View:getviewportwidth()
	return self.viewportwidth
end
function LOVELi.View:getviewportheight()
	return self.viewportheight
end
function LOVELi.View:getrenderx()
	return LOVELi.Math.clipx(self:getviewportx(), self:getscreenx() )
end
function LOVELi.View:getrendery()
	return LOVELi.Math.clipy(self:getviewporty(), self:getscreeny() )
end
function LOVELi.View:getrenderwidth()
	return LOVELi.Math.clipwidth(self:getviewportx(), self:getviewportwidth(), self:getscreenx(), self:getscreenwidth() )
end
function LOVELi.View:getrenderheight()
	return LOVELi.Math.clipheight(self:getviewporty(), self:getviewportheight(), self:getscreeny(), self:getscreenheight() )
end
function LOVELi.View:getcanvas()
	return self.canvas
end
--TODO: Do not use
function LOVELi.View:invalidatemeasure() 
	self:measure(self.availablewidth, self.availableheight)
end
--TODO: Do not use
function LOVELi.View:invalidatearrange() 
	self:arrange(self.screenx, self.screeny, self.screenwidth, self.screenheight, self.viewportx, self.viewporty, self.viewportwidth, self.viewportheight)
end
function LOVELi.View:invalidate()
	self.invalid = true
	for _, control in ipairs(self:getcontrols() ) do
		control:invalidate()
	end
end
function LOVELi.View:getisfocusable() -- virtual
	return false
end
function LOVELi.View:init(layoutmanager) -- virtual
	if self.layoutmanager then
		error("View's LayoutManager is already set.")
	end
	self.layoutmanager = layoutmanager
end
function LOVELi.View:measure(availablewidth, availableheight) -- virtual
	self.availablewidth = availablewidth
	self.availableheight = availableheight
	if self:getwidth() == "*" then
		self.desiredwidth = math.min(self:getmaxwidth(), math.max(self:getminwidth(), availablewidth - self:getmargin():gethorizontal() ) )
	elseif self:getwidth() == "auto" then
		error("View width can not be set to auto.")
	else
		self.desiredwidth = self:getwidth()
	end
	if self:getheight() == "*" then
		self.desiredheight = math.min(self:getmaxheight(), math.max(self:getminheight(), availableheight - self:getmargin():getvertical() ) )
	elseif self:getheight() == "auto" then
		error("View height can not be set to auto.")
	else
		self.desiredheight = self:getheight()
	end
end
function LOVELi.View:arrange(screenx, screeny, screenwidth, screenheight, viewportx, viewporty, viewportwidth, viewportheight) -- virtual
	self.screenx = screenx
	self.screeny = screeny
	self.screenwidth = screenwidth
	self.screenheight = screenheight
	self.viewportx = viewportx
	self.viewporty = viewporty
	self.viewportwidth = viewportwidth
	self.viewportheight = viewportheight
end
function LOVELi.View:update(dt) -- virtual
end
function LOVELi.View:draw() 
	if self.invalid then
		self.invalid = false
		local width = self:getrenderwidth()
		local height = self:getrenderheight()
		if width > 0 and height > 0 then
			local canvas = self:getcanvas()
			if not canvas or canvas:getWidth() ~= width or canvas:getHeight() ~= height then
				canvas = love.graphics.newCanvas(math.floor(width + 0.5), math.floor(height + 0.5) ) -- Snap to grid
				self.canvas = canvas
			end
			love.graphics.setCanvas(canvas)
			love.graphics.clear(0, 0, 0, 0) -- Transparent
			self:render(math.floor(self:getscreenx() - self:getrenderx() ), math.floor(self:getscreeny() - self:getrendery() ) ) -- Snap to grid
			love.graphics.setCanvas(nil)
		else
			self.canvas = nil
		end
	end
end
function LOVELi.View:render(x, y) -- virtual
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
function LOVELi.View:type()
	return "View"
end