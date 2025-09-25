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

LOVELi.AnimatedLabel = {}
LOVELi.AnimatedLabel.__index = LOVELi.AnimatedLabel
setmetatable(LOVELi.AnimatedLabel, LOVELi.Label)
function LOVELi.AnimatedLabel:new(options) -- LOVELi.AnimatedLabel LOVELi.AnimatedLabel:new( { bool isplaying, double duration, double elapsed, string text, bool ismultiline, Font font, Union<"start", "center", "end"> horizontaltextalignment, Union<"start", "center", "end"> verticaltextalignment, LOVELi.Color textcolor, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.Label.new(self, options)
	if options.isplaying == nil then
		o.isplaying = LOVELi.Property.parse(false)
	else
		o.isplaying = LOVELi.Property.parse(options.isplaying)
	end
	o.duration = LOVELi.Property.parse(options.duration or 1) -- in seconds
	o.elapsed = LOVELi.Property.parse(options.elapsed or 0) -- in seconds
	return o
end
function LOVELi.AnimatedLabel:getisplaying()
	return self.isplaying:getvalue()
end
function LOVELi.AnimatedLabel:setisplaying(value)
	self.isplaying:setvalue(value)
end
function LOVELi.AnimatedLabel:getduration()
	return self.duration:getvalue()
end
function LOVELi.AnimatedLabel:setduration(value)
	self.duration:setvalue(value)
end
function LOVELi.AnimatedLabel:getelapsed()
	return self.elapsed:getvalue()
end
function LOVELi.AnimatedLabel:setelapsed(value)
	self.elapsed:setvalue(value)
end
function LOVELi.AnimatedLabel:update(dt) -- override
	if self:getisplaying() and self:getelapsed() < self:getduration() then
		self:setelapsed(math.min(self:getduration(), self:getelapsed() + dt) )
		self:invalidate()
	end
end
function LOVELi.AnimatedLabel:render(x, y) -- override
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
	love.graphics.setColor(self:gettextcolor():getrgba() )
	local wrappedtext
	if self:getismultiline() then
		_, wrappedtext = self:getfont():getWrap(string.sub(self:gettext(), 1, math.floor(self:getelapsed() / self:getduration() * #self:gettext() ) ), self:getdesiredwidth() )
	else
		wrappedtext = { string.sub(self:gettext(), 1, math.floor(self:getelapsed() / self:getduration() * #self:gettext() ) ) }
	end
	for i, text in ipairs(wrappedtext) do
		local horizontaltextalignment
		if self:gethorizontaltextalignment() == "start" then
			horizontaltextalignment = 0
		elseif self:gethorizontaltextalignment() == "center" then
			horizontaltextalignment = ( self:getdesiredwidth() - self:getfont():getWidth(text) ) / 2
		elseif self:gethorizontaltextalignment() == "end" then
			horizontaltextalignment = self:getdesiredwidth() - self:getfont():getWidth(text)
		end
		local verticaltextalignment
		if self:getverticaltextalignment() == "start" then
			verticaltextalignment = 0
		elseif self:getverticaltextalignment() == "center" then
			verticaltextalignment = ( self:getdesiredheight() - #wrappedtext * self:getfont():getHeight() ) / 2
		elseif self:getverticaltextalignment() == "end" then
			verticaltextalignment = self:getdesiredheight() - #wrappedtext * self:getfont():getHeight()
		end
		love.graphics.print(
			text, 
			self:getfont(),
			x + self:getmargin():getleft() + horizontaltextalignment, 
			y + self:getmargin():gettop() + verticaltextalignment + self:getfont():getHeight() * (i - 1) )
	end
end
function LOVELi.AnimatedLabel:type() -- override
	return "AnimatedLabel"
end