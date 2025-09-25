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

LOVELi.MaskedTextBox = {}
LOVELi.MaskedTextBox.__index = LOVELi.MaskedTextBox
setmetatable(LOVELi.MaskedTextBox, LOVELi.View)
function LOVELi.MaskedTextBox:new(options) -- LOVELi.MaskedTextBox LOVELi.MaskedTextBox:new( { Action<LOVELi.MaskedTextBox sender, string oldvalue, string newvalue> textchanged, string text, string mask, Dictionary<string, object> patterns, Font font, Union<"start", "center", "end"> horizontaltextalignment, Union<"start", "center", "end"> verticaltextalignment, LOVELi.Color textcolor, LOVELi.Color backgroundcolor, LOVELi.Color bordercolor, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)
	o.textchanging = options.textchanging
	o.textchanged = options.textchanged
	o.text = LOVELi.Property.parse(options.text or "")
	o.mask = LOVELi.Property.parse(options.mask or "")
	o.patterns = LOVELi.Property.parse(options.patterns or {} )
	o.font = LOVELi.Property.parse(options.font or love.graphics.getFont() )
	o.horizontaltextalignment = LOVELi.Property.parse(options.horizontaltextalignment	or "start")
	o.verticaltextalignment = LOVELi.Property.parse(options.verticaltextalignment or "center")
	o.textcolor = LOVELi.Property.parse(options.textcolor or LOVELi.Color.parse(0x000000FF) )
	o.backgroundcolor = LOVELi.Property.parse(options.backgroundcolor or LOVELi.Color.parse(0xFFFFFFFF) )
	o.bordercolor = LOVELi.Property.parse(options.bordercolor or LOVELi.Color.parse(0xC0C0C0FF) )
	return o
end
function LOVELi.MaskedTextBox:gettextchanging()
	return self.textchanging
end
function LOVELi.MaskedTextBox:gettextchanged()
	return self.textchanged
end
function LOVELi.MaskedTextBox:gettext()
	return self.text:getvalue()
end
function LOVELi.MaskedTextBox:settext(value)
	self.text:setvalue(value)
end
function LOVELi.MaskedTextBox:getmask()
	return self.mask:getvalue()
end
function LOVELi.MaskedTextBox:sermask(value)
	self.mask:setvalue(value)
end
function LOVELi.MaskedTextBox:getpatterns()
	return self.patterns:getvalue()
end
function LOVELi.MaskedTextBox:setpatterns(value)
	self.patterns:setvalue(value)
end
function LOVELi.MaskedTextBox:getfont()
	return self.font:getvalue()
end
function LOVELi.MaskedTextBox:setfont(value)
	self.font:setvalue(value)
end
function LOVELi.MaskedTextBox:gethorizontaltextalignment()
	return self.horizontaltextalignment:getvalue()
end
function LOVELi.MaskedTextBox:sethorizontaltextalignment(value)
	self.horizontaltextalignment:setvalue(value)
end
function LOVELi.MaskedTextBox:getverticaltextalignment()
	return self.verticaltextalignment:getvalue()
end
function LOVELi.MaskedTextBox:setverticaltextalignment(value)
	self.verticaltextalignment:setvalue(value)
end
function LOVELi.MaskedTextBox:gettextcolor()
	return self.textcolor:getvalue()
end
function LOVELi.MaskedTextBox:settextcolor(value)
	self.textcolor:setvalue(value)
end
function LOVELi.MaskedTextBox:getbackgroundcolor()
	return self.backgroundcolor:getvalue()
end
function LOVELi.MaskedTextBox:setbackgroundcolor(value)
	self.backgroundcolor:setvalue(value)
end
function LOVELi.MaskedTextBox:getbordercolor()
	return self.bordercolor:getvalue()
end
function LOVELi.MaskedTextBox:setbordercolor(value)
	self.bordercolor:setvalue(value)
end
function LOVELi.MaskedTextBox:getisfocusable() -- override
	return true
end
function LOVELi.MaskedTextBox:init(layoutmanager) -- override
	if self.layoutmanager then
		error("MaskedTextBox's LayoutManager is already set.")
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
			local mask = self:getmask()
			if #oldvalue > 0 then			
				local newvalue = string.sub(oldvalue, 1, -2)
				while #newvalue > 0 do
					local maskcharacter = string.sub(mask, #newvalue, #newvalue)
					local pattern = nil
					for key, options in pairs(self:getpatterns() ) do
						if maskcharacter == key then
							pattern = options.pattern
							break
						end
					end
					if pattern then
						break
					else
						newvalue = string.sub(newvalue, 1, -2)
					end
				end
				ontextchange(oldvalue, newvalue)
			end			
		end
	end)
	local function stringinsert(self, text, position)
		return string.sub(self, 1, position - 1) .. text .. string.sub(self, position)
	end
	layoutmanager:subscribe("textinput", self, function(text)
		local oldvalue = self:gettext()
		local mask = self:getmask()
		if #oldvalue < #mask then
			local newvalue = oldvalue .. text
			while #newvalue <= #mask do
				local maskcharacter = string.sub(mask, #newvalue, #newvalue)
				local pattern = nil
				for key, options in pairs(self:getpatterns() ) do
					if maskcharacter == key then
						pattern = options.pattern
						break
					end
				end
				if pattern then
					if string.find(text, pattern) then
						ontextchange(oldvalue, newvalue)	
					end
					break
				else
					newvalue = stringinsert(newvalue, maskcharacter, #newvalue)
				end				
			end
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
function LOVELi.MaskedTextBox:measure(availablewidth, availableheight) -- override
	self.availablewidth = availablewidth
	self.availableheight = availableheight
	if self:getwidth() == "*" then
			self.desiredwidth = math.min(self:getmaxwidth(), math.max(self:getminwidth(), availablewidth - self:getmargin():gethorizontal() ) )
	elseif self:getwidth() == "auto" then
		self.desiredwidth = self:getfont():getWidth(self:getmask() ) + 10
	else
		self.desiredwidth = self:getwidth()
	end
	if self:getheight() == "*" then
		self.desiredheight = math.min(self:getmaxheight(), math.max(self:getminheight(), availableheight - self:getmargin():getvertical() ) )
	elseif self:getheight() == "auto" then
		self.desiredheight = self:getfont():getHeight() + 10
	else
		self.desiredheight = self:getheight()
	end
end
function LOVELi.MaskedTextBox:render(x, y) -- override
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
	local text = self:gettext()
	local mask = self:getmask()
	if #text < #mask then
		for i = #text + 1, #mask do
			local maskcharacter = string.sub(mask, i, i)
			local pattern = nil
			for key, options in pairs(self:getpatterns() ) do
				if maskcharacter == key then
					pattern = options.pattern
					break
				end
			end
			if pattern then
				text = text .. "_"
			else
				text = text .. maskcharacter
			end
		end
	end	
	local wrappedtext = { text }
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
function LOVELi.MaskedTextBox:type() -- override
	return "MaskedTextBox"
end