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

LOVELi.Label = {}
LOVELi.Label.__index = LOVELi.Label
setmetatable(LOVELi.Label, LOVELi.View)
function LOVELi.Label:new(options) -- LOVELi.Label LOVELi.Label:new( { string text, bool ismultiline, Font font, Union<"start", "center", "end"> horizontaltextalignment, Union<"start", "center", "end"> verticaltextalignment, LOVELi.Color textcolor, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)
	o.text = LOVELi.Property.parse(options.text or "")
	if options.ismultiline == nil then
		o.ismultiline = LOVELi.Property.parse(false)
	else
		o.ismultiline = LOVELi.Property.parse(options.ismultiline)
	end
	o.font = LOVELi.Property.parse(options.font or love.graphics.getFont() )
	o.horizontaltextalignment = LOVELi.Property.parse(options.horizontaltextalignment	or "center")
	o.verticaltextalignment = LOVELi.Property.parse(options.verticaltextalignment or "center")
	o.textcolor = LOVELi.Property.parse(options.textcolor or LOVELi.Color.parse(0x000000FF) )
	return o
end
function LOVELi.Label:gettext()
	return self.text:getvalue()
end
function LOVELi.Label:settext(value)
	self.text:setvalue(value)
end
function LOVELi.Label:getismultiline()
	return self.ismultiline:getvalue()
end
function LOVELi.Label:setismultiline(value)
	self.ismultiline:setvalue(value)
end
function LOVELi.Label:getfont()
	return self.font:getvalue()
end
function LOVELi.Label:setfont(value)
	self.font:setvalue(value)
end
function LOVELi.Label:gethorizontaltextalignment()
	return self.horizontaltextalignment:getvalue()
end
function LOVELi.Label:sethorizontaltextalignment(value)
	self.horizontaltextalignment:setvalue(value)
end
function LOVELi.Label:getverticaltextalignment()
	return self.verticaltextalignment:getvalue()
end
function LOVELi.Label:setverticaltextalignment(value)
	self.verticaltextalignment:setvalue(value)
end
function LOVELi.Label:gettextcolor()
	return self.textcolor:getvalue()
end
function LOVELi.Label:settextcolor(value)
	self.textcolor:setvalue(value)
end
function LOVELi.Label:measure(availablewidth, availableheight) -- override
	self.availablewidth = availablewidth
	self.availableheight = availableheight
	if self:getwidth() == "*" then
		self.desiredwidth = math.min(self:getmaxwidth(), math.max(self:getminwidth(), availablewidth - self:getmargin():gethorizontal() ) )
	elseif self:getwidth() == "auto" then
		self.desiredwidth = self:getfont():getWidth(self:gettext() )
	else
		self.desiredwidth = self:getwidth()
	end
	if self:getheight() == "*" then
		self.desiredheight = math.min(self:getmaxheight(), math.max(self:getminheight(), availableheight - self:getmargin():getvertical() ) )
	elseif self:getheight() == "auto" then
		self.desiredheight = #select(2, self:getfont():getWrap(self:gettext(), self:getdesiredwidth() ) ) * self:getfont():getHeight()
	else
		self.desiredheight = self:getheight()
	end
end
function LOVELi.Label:render(x, y) -- override
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
		_, wrappedtext = self:getfont():getWrap(self:gettext(), self:getdesiredwidth() )
	else
		wrappedtext = { self:gettext() }
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
function LOVELi.Label:type() -- override
	return "Label"
end