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

LOVELi.Picker = {}
LOVELi.Picker.__index = LOVELi.Picker
setmetatable(LOVELi.Picker, LOVELi.View)
function LOVELi.Picker:new(options) -- LOVELi.Picker LOVELi.Picker:new( { Action<LOVELi.Picker, int? oldvalue, int? newvalue> selectedindexchanged, string[] itemssource, int? selectedindex, string text, bool ismultiline, Font font, Union<"start", "center", "end"> horizontaltextalignment, Union<"start", "center", "end"> verticaltextalignment, LOVELi.Color textcolor, LOVELi.Color backgroundcolor, LOVELi.Color bordercolor, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)
	o.selectedindexchanging = options.selectedindexchanging
	o.selectedindexchanged = options.selectedindexchanged
	o.itemssource = LOVELi.Property.parse(options.itemssource or {} )
	o.selectedindex = LOVELi.Property.parse(options.selectedindex)
	o.text = LOVELi.Property.parse(options.text or "")
	if options.ismultiline == nil then
		o.ismultiline = LOVELi.Property.parse(false)
	else
		o.ismultiline = LOVELi.Property.parse(options.ismultiline)
	end
	o.font = LOVELi.Property.parse(options.font or love.graphics.getFont() )
	o.horizontaltextalignment = LOVELi.Property.parse(options.horizontaltextalignment	or "start")
	o.verticaltextalignment = LOVELi.Property.parse(options.verticaltextalignment or "center")
	o.textcolor = LOVELi.Property.parse(options.textcolor or LOVELi.Color.parse(0x000000FF) )
	o.backgroundcolor = LOVELi.Property.parse(options.backgroundcolor or LOVELi.Color.parse(0xFFFFFFFF) )
	o.bordercolor = LOVELi.Property.parse(options.bordercolor or LOVELi.Color.parse(0xC0C0C0FF) )	
	if #options.itemssource > 0 then
		local stacklayout = LOVELi.StackLayout:new{ width = "*", height = "auto", zindex = 1 }
		for i, item in ipairs(o:getitemssource() ) do
			local text
			if type(item) == "string" then
				text = item
			else
				text = item:tostring()
			end
			stacklayout:with(LOVELi.Button:new{ text = text, font = o.font, horizontaltextalignment = o.horizontaltextalignment, verticaltextalignment = o.verticaltextalignment, textcolor = o.textcolor, backgroundcolor = o.backgroundcolor, bordercolor = o.bordercolor, width = "*", height = "auto", zindex = 1, clicked = function(button)
				local oldvalue = o:getselectedindex()
				local newvalue = i
				if oldvalue ~= newvalue then
					if not o.selectedindexchanging or o:selectedindexchanging(oldvalue, newvalue) then
						o:setselectedindex(newvalue)
						o:settext(button:gettext() )
						o:invalidate()
						if o.selectedindexchanged then
							o:selectedindexchanged(oldvalue, newvalue)
						end
					end
				end
				o.dropdownmenu:setisvisible(false)
				o.dropdownmenu:invalidate()
			end } )
		end
		o.dropdownmenu = LOVELi.ScrollView:new{ width = "*", height = "*", zindex = 1, isvisible = false }
			:with(LOVELi.Border:new{ backgroundcolor = o.backgroundcolor, width = "*", height = "auto", zindex = 1 }
				:with(stacklayout) 
			)
		table.insert(o.controls, o.dropdownmenu)
	end
	return o
end
function LOVELi.Picker:getselectedindexchanging()
	return self.selectedindexchanging
end
function LOVELi.Picker:getselectedindexchanged()
	return self.selectedindexchanged
end
function LOVELi.Picker:getitemssource()
	return self.itemssource:getvalue()
end
function LOVELi.Picker:setitemssource(value)
	self.itemssource:setvalue(value)
end
function LOVELi.Picker:getselectedindex()
	return self.selectedindex:getvalue()
end
function LOVELi.Picker:setselectedindex(value)
	self.selectedindex:setvalue(value)
end
function LOVELi.Picker:gettext()
	return self.text:getvalue()
end
function LOVELi.Picker:settext(value)
	self.text:setvalue(value)
end
function LOVELi.Picker:getismultiline()
	return self.ismultiline:getvalue()
end
function LOVELi.Picker:setismultiline(value)
	self.ismultiline:setvalue(value)
end
function LOVELi.Picker:getfont()
	return self.font:getvalue()
end
function LOVELi.Picker:setfont(value)
	self.font:setvalue(value)
end
function LOVELi.Picker:gethorizontaltextalignment()
	return self.horizontaltextalignment:getvalue()
end
function LOVELi.Picker:sethorizontaltextalignment(value)
	self.horizontaltextalignment:setvalue(value)
end
function LOVELi.Picker:getverticaltextalignment()
	return self.verticaltextalignment:getvalue()
end
function LOVELi.Picker:setverticaltextalignment(value)
	self.verticaltextalignment:setvalue(value)
end
function LOVELi.Picker:gettextcolor()
	return self.textcolor:getvalue()
end
function LOVELi.Picker:settextcolor(value)
	self.textcolor:setvalue(value)
end
function LOVELi.Picker:getbackgroundcolor()
	return self.backgroundcolor:getvalue()
end
function LOVELi.Picker:setbackgroundcolor(value)
	self.backgroundcolor:setvalue(value)
end
function LOVELi.Picker:getbordercolor()
	return self.bordercolor:getvalue()
end
function LOVELi.Picker:setbordercolor(value)
	self.bordercolor:setvalue(value)
end
function LOVELi.Picker:getdropdownmenu()
	return self.dropdownmenu
end
function LOVELi.Picker:getisfocusable() -- override
	return true
end
function LOVELi.Picker:init(layoutmanager) -- override
	if self.layoutmanager then
		error("Picker's LayoutManager is already set.")
	end
	self.layoutmanager = layoutmanager	
	local function toggledropdownmenu()
		local dropdownmenu = self:getdropdownmenu()
		if dropdownmenu then
			dropdownmenu:setisvisible(not dropdownmenu:getisvisible() )
			dropdownmenu:invalidate()
		end
	end
	layoutmanager:subscribe("keypressed", self, function(key, scancode, isrepeat)
		if key == "space" or key == "return" or key == "kpenter" then
			toggledropdownmenu()
		end
	end)
	layoutmanager:subscribe("mousepressed", self, function(x, y, button, istouch, presses)		
		toggledropdownmenu()
	end)
end
function LOVELi.Picker:measure(availablewidth, availableheight) -- override
	self.availablewidth = availablewidth
	self.availableheight = availableheight
	if self:getwidth() == "*" then
		self.desiredwidth = math.min(self:getmaxwidth(), math.max(self:getminwidth(), availablewidth - self:getmargin():gethorizontal() ) )
	elseif self:getwidth() == "auto" then
		self.desiredwidth = self:getfont():getWidth(self:gettext() ) + 10 + 20
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
	local dropdownmenu = self:getdropdownmenu()
	if dropdownmenu then
		dropdownmenu:measure(self:getdesiredwidth(), 100)
	end	
end
function LOVELi.Picker:arrange(screenx, screeny, screenwidth, screenheight, viewportx, viewporty, viewportwidth, viewportheight) -- override	
	self.screenx = screenx
	self.screeny = screeny
	self.screenwidth = screenwidth
	self.screenheight = screenheight
	self.viewportx = viewportx
	self.viewporty = viewporty
	self.viewportwidth = viewportwidth
	self.viewportheight = viewportheight	
	local dropdownmenu = self:getdropdownmenu()
	if dropdownmenu then
		screenx = screenx + self:getmargin():getleft() + self:getx()
		screeny = screeny + self:getdesiredheight() + self:getmargin():getvertical() + self:gety()
		screenwidth = dropdownmenu:getdesiredwidth() + dropdownmenu:getmargin():gethorizontal()
		screenheight = dropdownmenu:getdesiredheight() + dropdownmenu:getmargin():getvertical()
		viewportx = 0
		viewporty = 0
		viewportwidth = love.graphics:getWidth()
		viewportheight = love.graphics:getHeight()
		dropdownmenu:arrange(
			screenx,
			screeny,
			screenwidth,
			screenheight,
			
			LOVELi.Math.clipx(viewportx, screenx),
			LOVELi.Math.clipy(viewporty, screeny),
			LOVELi.Math.clipwidth(viewportx, viewportwidth, screenx, screenwidth),
			LOVELi.Math.clipheight(viewporty, viewportheight, screeny, screenheight) )
	end
end
function LOVELi.Picker:render(x, y) -- override
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
	love.graphics.line(
		x + self:getmargin():getleft() + self:getdesiredwidth() - 15, 
		y + self:getmargin():gettop() + self:getdesiredheight() / 2 - 1, 			
		x + self:getmargin():getleft() + self:getdesiredwidth() - 10, 
		y + self:getmargin():gettop() + self:getdesiredheight() / 2 + 4)
	love.graphics.line(
		x + self:getmargin():getleft() + self:getdesiredwidth() - 10, 
		y + self:getmargin():gettop() + self:getdesiredheight() / 2 + 4, 			
		x + self:getmargin():getleft() + self:getdesiredwidth() - 5, 
		y + self:getmargin():gettop() + self:getdesiredheight() / 2 - 1)	
	local wrappedtext
	if self:getismultiline() then
		_, wrappedtext = self:getfont():getWrap(self:gettext(), self:getdesiredwidth() - 10 - 20)
	else
		wrappedtext = { self:gettext() }
	end	
	for i, text in ipairs(wrappedtext) do
		local horizontaltextalignment
		if self:gethorizontaltextalignment() == "start" then
			horizontaltextalignment = 5
		elseif self:gethorizontaltextalignment() == "center" then
			horizontaltextalignment = ( self:getdesiredwidth() - 5 - 20 - self:getfont():getWidth(text) ) / 2
		elseif self:gethorizontaltextalignment() == "end" then
			horizontaltextalignment = self:getdesiredwidth() - self:getfont():getWidth(text) - 5 - 20
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
function LOVELi.Picker:type() -- override
	return "Picker"
end