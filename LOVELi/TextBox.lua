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

LOVELi.TextBox = {}
LOVELi.TextBox.__index = LOVELi.TextBox
setmetatable(LOVELi.TextBox, LOVELi.View)
function LOVELi.TextBox:new(options) -- LOVELi.TextBox LOVELi.TextBox:new( { Action<LOVELi.TextBox sender, string oldvalue, string newvalue> textchanged, string text, bool ismultiline, bool ispassword, int maxlength, Font font, Union<"start", "center", "end"> horizontaltextalignment, Union<"start", "center", "end"> verticaltextalignment, LOVELi.Color textcolor, LOVELi.Color backgroundcolor, LOVELi.Color bordercolor, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)
	o.textchanging = options.textchanging
	o.textchanged = options.textchanged
	o.text = LOVELi.Property.parse(options.text or "")
	if options.ismultiline == nil then
		o.ismultiline = LOVELi.Property.parse(false)
	else
		o.ismultiline = LOVELi.Property.parse(options.ismultiline)
	end
	if options.ispassword == nil then
		o.ispassword = LOVELi.Property.parse(false)
	else
		o.ispassword = LOVELi.Property.parse(options.ispassword)
	end
	o.maxlength = LOVELi.Property.parse(options.maxlength or math.huge)
	o.font = LOVELi.Property.parse(options.font or love.graphics.getFont() )
	o.horizontaltextalignment = LOVELi.Property.parse(options.horizontaltextalignment	or "start")
	o.verticaltextalignment = LOVELi.Property.parse(options.verticaltextalignment or "center")
	o.textcolor = LOVELi.Property.parse(options.textcolor or LOVELi.Color.parse(0x000000FF) )
	o.backgroundcolor = LOVELi.Property.parse(options.backgroundcolor or LOVELi.Color.parse(0xFFFFFFFF) )
	o.bordercolor = LOVELi.Property.parse(options.bordercolor or LOVELi.Color.parse(0xC0C0C0FF) )
	return o
end
function LOVELi.TextBox:gettextchanging()
	return self.textchanging
end
function LOVELi.TextBox:gettextchanged()
	return self.textchanged
end
function LOVELi.TextBox:gettext()
	return self.text:getvalue()
end
function LOVELi.TextBox:settext(value)
	self.text:setvalue(value)
end
function LOVELi.TextBox:getismultiline()
	return self.ismultiline:getvalue()
end
function LOVELi.TextBox:setismultiline(value)
	self.ismultiline:setvalue(value)
end
function LOVELi.TextBox:getispassword()
	return self.ispassword:getvalue()
end
function LOVELi.TextBox:setispassword(value)
	self.ispassword:setvalue(value)
end
function LOVELi.TextBox:getmaxlength()
	return self.maxlength:getvalue()
end
function LOVELi.TextBox:setmaxlength(value)
	self.maxlength:setvalue(value)
end
function LOVELi.TextBox:getfont()
	return self.font:getvalue()
end
function LOVELi.TextBox:setfont(value)
	self.font:setvalue(value)
end
function LOVELi.TextBox:gethorizontaltextalignment()
	return self.horizontaltextalignment:getvalue()
end
function LOVELi.TextBox:sethorizontaltextalignment(value)
	self.horizontaltextalignment:setvalue(value)
end
function LOVELi.TextBox:getverticaltextalignment()
	return self.verticaltextalignment:getvalue()
end
function LOVELi.TextBox:setverticaltextalignment(value)
	self.verticaltextalignment:setvalue(value)
end
function LOVELi.TextBox:gettextcolor()
	return self.textcolor:getvalue()
end
function LOVELi.TextBox:settextcolor(value)
	self.textcolor:setvalue(value)
end
function LOVELi.TextBox:getbackgroundcolor()
	return self.backgroundcolor:getvalue()
end
function LOVELi.TextBox:setbackgroundcolor(value)
	self.backgroundcolor:setvalue(value)
end
function LOVELi.TextBox:getbordercolor()
	return self.bordercolor:getvalue()
end
function LOVELi.TextBox:setbordercolor(value)
	self.bordercolor:setvalue(value)
end
function LOVELi.TextBox:getisfocusable() -- override
	return true
end
function LOVELi.TextBox:init(layoutmanager) -- override
	if self.layoutmanager then
		error("TextBox's LayoutManager is already set.")
	end
	self.layoutmanager = layoutmanager
	local function ontextchange(oldvalue, newvalue)
		if not self.textchanging or self:textchanging(oldvalue, newvalue) then
			self:settext(newvalue)
			self:invalidate()
			if self.textchanged then
				self:textchanged(oldvalue, newvalue)
			end
		end
	end
	layoutmanager:subscribe("keypressed", self, function(key, scancode, isrepeat)
		if key == "backspace" then
			local oldvalue = self:gettext()			
			if #oldvalue > 0 then
				local utf8 = require("utf8")
				local byteoffset = utf8.offset(oldvalue, -1)
				local newvalue = string.sub(oldvalue, 1, byteoffset - 1)
				ontextchange(oldvalue, newvalue)
			end
		end
	end)
	layoutmanager:subscribe("textinput", self, function(text)
		local oldvalue = self:gettext()		
		if #oldvalue < self:getmaxlength() then
			local newvalue = oldvalue .. text
			ontextchange(oldvalue, newvalue)
		end
	end)
	layoutmanager:subscribe("mousepressed", self, function(x, y, button, istouch, presses)
		--TODO: Cursor
	end)
	layoutmanager:subscribe("focused", self, function()
		love.keyboard.setTextInput(true)
	end)
	layoutmanager:subscribe("unfocused", self, function()
		love.keyboard.setTextInput(false)
	end)
end
function LOVELi.TextBox:measure(availablewidth, availableheight) -- override
	self.availablewidth = availablewidth
	self.availableheight = availableheight
	if self:getwidth() == "*" then
			self.desiredwidth = math.min(self:getmaxwidth(), math.max(self:getminwidth(), availablewidth - self:getmargin():gethorizontal() ) )
	elseif self:getwidth() == "auto" then
		self.desiredwidth = self:getfont():getWidth(self:gettext() ) + 10
	else
		self.desiredwidth = self:getwidth()
	end
	if self:getheight() == "*" then
			self.desiredheight = math.min(self:getmaxheight(), math.max(self:getminheight(), availableheight - self:getmargin():getvertical() ) )
	elseif self:getheight() == "auto" then
		self.desiredheight = #select(2, self:getfont():getWrap(self:gettext(), self:getdesiredwidth() ) ) * self:getfont():getHeight() + 10
	else
		self.desiredheight = self:getheight()
	end
end
function LOVELi.TextBox:render(x, y) -- override
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
	love.graphics.setColor(self:getbackgroundcolor():getrgba() )	
	love.graphics.rectangle(
		"fill", 
		x + self:getmargin():getleft(), 
		y + self:getmargin():gettop(), 
		self:getdesiredwidth(), 
		self:getdesiredheight() )
	love.graphics.setColor(self:gettextcolor():getrgba() )
	local text
	if self:getispassword() then
		text = string.gsub(self:gettext(), ".", "*")
	else
		text = self:gettext()
	end
	local wrappedtext
	if self:getismultiline() then
		_, wrappedtext = self:getfont():getWrap(text, self:getdesiredwidth() - 10)
	else
		wrappedtext = { text }
	end	
	for i, text in ipairs(wrappedtext) do
		local horizontaltextalignment
		if self:gethorizontaltextalignment() == "start" then
			horizontaltextalignment = 5
		elseif self:gethorizontaltextalignment() == "center" then
			horizontaltextalignment = ( self:getdesiredwidth() - self:getfont():getWidth(text) ) / 2
		elseif self:gethorizontaltextalignment() == "end" then
			horizontaltextalignment = self:getdesiredwidth() - self:getfont():getWidth(text) - 5
		end
		local verticaltextalignment
		if self:getverticaltextalignment() == "start" then
			verticaltextalignment = 5
		elseif self:getverticaltextalignment() == "center" then
			verticaltextalignment = ( self:getdesiredheight() - #wrappedtext * self:getfont():getHeight() ) / 2
		elseif self:getverticaltextalignment() == "end" then
			verticaltextalignment = self:getdesiredheight() - #wrappedtext * self:getfont():getHeight() - 5
		end
		love.graphics.print(
			text, 
			self:getfont(),
			x + self:getmargin():getleft() + horizontaltextalignment, 
			y + self:getmargin():gettop() + verticaltextalignment + self:getfont():getHeight() * (i - 1) )
	end
	love.graphics.setColor(self:getbordercolor():getrgba() )
	love.graphics.rectangle(
		"line",
		x + self:getmargin():getleft() + 0.5, 
		y + self:getmargin():gettop() + 0.5,
		self:getdesiredwidth() - 1,
		self:getdesiredheight() - 1)
end
function LOVELi.TextBox:type() -- override
	return "TextBox"
end