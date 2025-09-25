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

LOVELi.RadioButton = {
	radiobuttons = {}
}
LOVELi.RadioButton.__index = LOVELi.RadioButton
setmetatable(LOVELi.RadioButton, LOVELi.View)
function LOVELi.RadioButton:new(options) -- LOVELi.RadioButton LOVELi.RadioButton:new( { Action<LOVELi.RadioButton sender, bool oldvalue, bool newvalue> checkedchanged, bool ischecked, string groupname, LOVELi.Color forecolor, LOVELi.Color backgroundcolor, LOVELi.Color bordercolor, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)
	o.checkedchanging = options.checkedchanging
	o.checkedchanged = options.checkedchanged
	o.ischecked = LOVELi.Property.parse(options.ischecked or false)
	o.groupname = LOVELi.Property.parse(options.groupname)
	o.forecolor = LOVELi.Property.parse(options.forecolor or LOVELi.Color.parse(0xFFFFFFFF) )
	o.backgroundcolor = LOVELi.Property.parse(options.backgroundcolor or LOVELi.Color.parse(0xC0C0C0FF) )
	o.bordercolor = LOVELi.Property.parse(options.bordercolor or LOVELi.Color.parse(0xFFFFFFFF) )
	return o
end
function LOVELi.RadioButton:getcheckedchanging()
	return self.checkedchanging
end
function LOVELi.RadioButton:getcheckedchanged()
	return self.checkedchanged
end
function LOVELi.RadioButton:getischecked()
	return self.ischecked:getvalue()
end
function LOVELi.RadioButton:setischecked(value)
	self.ischecked:setvalue(value)
end
function LOVELi.RadioButton:getgroupname()
	return self.groupname:getvalue()
end
function LOVELi.RadioButton:setgroupname(value)
	self.groupname:setvalue(value)
end
function LOVELi.RadioButton:getforecolor()
	return self.forecolor:getvalue()
end
function LOVELi.RadioButton:setforecolor(value)
	self.forecolor:setvalue(value)
end
function LOVELi.RadioButton:getbackgroundcolor()
	return self.backgroundcolor:getvalue()
end
function LOVELi.RadioButton:setbackgroundcolor(value)
	self.backgroundcolor:setvalue(value)
end
function LOVELi.RadioButton:getbordercolor()
	return self.bordercolor:getvalue()
end
function LOVELi.RadioButton:setbordercolor(value)
	self.bordercolor:setvalue(value)
end
function LOVELi.RadioButton:getisfocusable() -- override
	return true
end
function LOVELi.RadioButton:init(layoutmanager) -- override
	if self.layoutmanager then
		error("RadioButton's LayoutManager is already set.")
	end
	self.layoutmanager = layoutmanager
	local function onchange()
		if not self:getischecked() then
			local oldvalue = self:getischecked()
			local newvalue = not oldvalue
			if not self.checkedchanging or self:checkedchanging(oldvalue, newvalue) then
				for _, control in ipairs(LOVELi.RadioButton.radiobuttons) do
					if control:getischecked() and control:getgroupname() == self:getgroupname() then
						local oldvalue = control:getischecked()
						local newvalue = not oldvalue
						control:setischecked(newvalue)
						control:invalidate()
						if control.checkedchanged then
							control:checkedchanged(oldvalue, newvalue)
						end
					end
				end					
				self:setischecked(newvalue)
				self:invalidate()
				if self.checkedchanged then
					self:checkedchanged(oldvalue, newvalue)
				end
			end
		end
	end
	layoutmanager:subscribe("keypressed", self, function(key, scancode, isrepeat)
		if key == "space" or key == "return" or key == "kpenter" then
			onchange()
		end
	end)
	layoutmanager:subscribe("mousepressed", self, function(x, y, button, istouch, presses)
		onchange()
	end)
	table.insert(LOVELi.RadioButton.radiobuttons, self)
end
function LOVELi.RadioButton:measure(availablewidth, availableheight) -- override
	self.availablewidth = availablewidth
	self.availableheight = availableheight
	if self:getwidth() == "*" then
		self.desiredwidth = math.min(self:getmaxwidth(), math.max(self:getminwidth(), availablewidth - self:getmargin():gethorizontal() ) )
	elseif self:getwidth() == "auto" then
		self.desiredwidth = 20
	else
		self.desiredwidth = self:getwidth()
	end
	if self:getheight() == "*" then
		self.desiredheight = math.min(self:getmaxheight(), math.max(self:getminheight(), availableheight - self:getmargin():getvertical() ) )
	elseif self:getheight() == "auto" then
		self.desiredheight = 20
	else
		self.desiredheight = self:getheight()
	end
end
function LOVELi.RadioButton:render(x, y) -- override
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
	love.graphics.circle(
		"fill", 
		x + self:getmargin():getleft() + self:getdesiredwidth() / 2, 
		y + self:getmargin():gettop() + self:getdesiredheight() / 2, 
		(self:getdesiredwidth() - 1) / 2)
	if self:getischecked() then
		love.graphics.setColor(self:getforecolor():getrgba() )
		love.graphics.circle(
			"fill", 
			x + self:getmargin():getleft() + self:getdesiredwidth() / 2, 
			y + self:getmargin():gettop() + self:getdesiredheight() / 2, 
			(self:getdesiredwidth() - 1) / 2 * 0.4)
	end
	love.graphics.setColor(self:getbordercolor():getrgba() )
	love.graphics.circle(
		"line",
		x + self:getmargin():getleft() + self:getdesiredwidth() / 2, 
		y + self:getmargin():gettop() + self:getdesiredheight() / 2, 
		(self:getdesiredwidth() - 1) / 2)
end
function LOVELi.RadioButton:type() -- override
	return "RadioButton"
end