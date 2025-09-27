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

LOVELi.LayoutManager = {}
LOVELi.LayoutManager.__index = LOVELi.LayoutManager
function LOVELi.LayoutManager:new(options) -- LOVELi.LayoutManager LOVELi.LayoutManager:new( { bool showlayoutlines, int x, int y, int width, int height, bool isvisible, bool isenabled } options)
	local o = {		
		showlayoutlines = LOVELi.Property.parse(options.showlayoutlines),
		x = LOVELi.Property.parse(options.x or 0),
		y = LOVELi.Property.parse(options.y or 0),
		width = LOVELi.Property.parse(options.width or love.graphics:getWidth() ),
		height = LOVELi.Property.parse(options.height or love.graphics:getHeight() ),
		rootcontrol = nil,
		eventhandlers = {},
		focusedcontrol = 0,
		initialized = false, -- private
		invalid = true, -- private
		alpha = 0, -- private
		minimumalpha = 0.25, -- private
		maximumalpha = 0.75, -- private
		interval = 2 -- private
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
function LOVELi.LayoutManager:getshowlayoutlines()
	return self.showlayoutlines:getvalue()
end
function LOVELi.LayoutManager:setshowlayoutlines(value)
	self.showlayoutlines:setvalue(value)
end
function LOVELi.LayoutManager:getx()
	return self.x:getvalue()
end
function LOVELi.LayoutManager:setx(value)
	self.x:setvalue(value)
end
function LOVELi.LayoutManager:gety()
	return self.y:getvalue()
end
function LOVELi.LayoutManager:sety(value)
	self.y:setvalue(value)
end
function LOVELi.LayoutManager:getwidth()
	return self.width:getvalue()
end
function LOVELi.LayoutManager:setwidth(value)
	self.width:setvalue(value)
end
function LOVELi.LayoutManager:getheight()
	return self.height:getvalue()
end
function LOVELi.LayoutManager:setheight(value)
	self.height:setvalue(value)
end
function LOVELi.LayoutManager:getisvisible()
	return self.isvisible:getvalue()
end
function LOVELi.LayoutManager:setisvisible(value)
	self.isvisible:setvalue(value)
end
function LOVELi.LayoutManager:getisenabled()
	return self.isenabled:getvalue()
end
function LOVELi.LayoutManager:setisenabled(value)
	self.isenabled:setvalue(value)
end
function LOVELi.LayoutManager:getrootcontrol()
	return self.rootcontrol
end
function LOVELi.LayoutManager:getcontrols(rootcontrol)
	local controls = {}
	local visit = {}	
	table.insert(visit, rootcontrol or self:getrootcontrol() )
	while #visit > 0 do
		local parent = table.remove(visit)
		table.insert(controls, parent)
		local t = parent:getcontrols()
		for i = #t, 1, -1 do
			table.insert(visit, t[i] )
		end
	end
	return controls
end
function LOVELi.LayoutManager:getvisiblecontrols(rootcontrol)
	local controls = {}
	local visit = {}	
	table.insert(visit, rootcontrol or self:getrootcontrol() )
	while #visit > 0 do
		local parent = table.remove(visit)
		if parent:getisvisible() then
			table.insert(controls, parent)
			local t = parent:getcontrols()
			for i = #t, 1, -1 do
				table.insert(visit, t[i] )
			end			
		end
	end
	return controls
end
function LOVELi.LayoutManager:getcontrol(name)
	for _, control in ipairs(self:getcontrols() ) do
		if control:getname() == name then
			return control
		end
	end
	return nil
end
function LOVELi.LayoutManager:geteventhandler(name)
	return self.eventhandlers[name]
end
function LOVELi.LayoutManager:getfocusedcontrol()
	return self.focusedcontrol
end
function LOVELi.LayoutManager:invalidate()
	self.invalid = true
	self.rootcontrol:invalidate()
end
function LOVELi.LayoutManager:with(rootcontrol)
	if self.rootcontrol then
		error("LayoutManager's root control is already set.")
	end
	self.rootcontrol = rootcontrol
	return self
end
function LOVELi.LayoutManager:subscribe(name, control, callback)
	if not self.eventhandlers[name] then
		self.eventhandlers[name] = {}
	end
	table.insert(self.eventhandlers[name], { control = control, callback = callback } )
end
function LOVELi.LayoutManager:unsubscribe(name, control)
	if self.eventhandlers[name] then
		for i, event in ipairs(self.eventhandlers[name] ) do
			if event.control == control then
				table.remove(self.eventhandlers[name], i)
				break
			end
		end
	end
end
function LOVELi.LayoutManager:keypressed(key, scancode, isrepeat)
	if self:getisenabled() then
		local direction = nil
		if key == "tab" then
			if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
				direction = "u"
			else
				direction = "d"
			end
		elseif key == "up" then
			direction = "u"
		elseif key == "down" then
			direction = "d"
		end		
		if direction == "u" or direction == "d" then
			local controls = self:getvisiblecontrols()
			local oldfocusedcontrol = self.focusedcontrol
			local newfocusedcontrol	= 0
			if direction == "u" then
				local k = oldfocusedcontrol
				if k == 0 then
					k = 1
				end
				for i = 1, #controls do
					local j = k - i
					if j < 1 then
						j = j + #controls
					end
					if controls[j]:getisvisible() and controls[j]:getisenabled() and controls[j]:getisfocusable() then
						newfocusedcontrol = j
						break
					end
				end
			else
				local focusedcontrol = oldfocusedcontrol
				for i = 1, #controls do
					local j = focusedcontrol + i
					if j > #controls then
						j = j - #controls
					end
					if controls[j]:getisvisible() and controls[j]:getisenabled() and controls[j]:getisfocusable() then
						newfocusedcontrol = j
						break
					end
				end
			end
			if oldfocusedcontrol ~= newfocusedcontrol then
				if oldfocusedcontrol > 0 then					
					local events = self:geteventhandler("unfocused")
					if events then
						for _, event in ipairs(events) do
							if event.control == controls[oldfocusedcontrol] then
								event.callback()
								break
							end
						end
					end
				end
				if newfocusedcontrol > 0 then
					local events = self:geteventhandler("focused")
					if events then
						for _, event in ipairs(events) do
							if event.control == controls[newfocusedcontrol] then
								event.callback()
								break
							end
						end
					end
				end
				self.focusedcontrol = newfocusedcontrol
			end
		else
			if self.focusedcontrol > 0 then
				local events = self:geteventhandler("keypressed")
				if events then
					local controls = self:getvisiblecontrols()
					for _, event in ipairs(events) do
						if event.control == controls[self.focusedcontrol] then
							event.callback(key, scancode, isrepeat)
							break
						end
					end
				end
			end
		end
	end
end
function LOVELi.LayoutManager:textinput(text)
	if self:getisenabled() then
		if self.focusedcontrol > 0 then
			local events = self:geteventhandler("textinput")
			if events then
				local controls = self:getvisiblecontrols()
				for _, event in ipairs(events) do
					if event.control == controls[self.focusedcontrol] then
						event.callback(text)
						break
					end
				end
			end
		end
	end
end
function LOVELi.LayoutManager:mousepressed(x, y, button, istouch, presses)
	if self:getisenabled() then
		local controls = self:getvisiblecontrols()
		local oldfocusedcontrol = self.focusedcontrol
		local newfocusedcontrol = 0
		local events = self:geteventhandler("mousepressed")
		if events then
			for _, event in ipairs(events) do
				if event.control:getisvisible() and event.control:getisenabled() then
					local renderwidth = event.control:getrenderwidth()
					local renderheight = event.control:getrenderheight()
					if renderwidth > 0 and renderheight > 0 then
						local renderx = event.control:getrenderx()
						local rendery = event.control:getrendery()
						if x >= renderx and x < renderx + renderwidth and y >= rendery and y < rendery + renderheight then
							event.callback(x, y, button, istouch, presses)
							if event.control:getisfocusable() then
								for j = 1, #controls do
									if event.control == controls[j] then
										newfocusedcontrol = j
										break
									end
								end
							end
							break
						end	
					end
				end
			end
		end
		if oldfocusedcontrol ~= newfocusedcontrol then
			if oldfocusedcontrol > 0 then
				local events = self:geteventhandler("unfocused")
				if events then
					for _, event in ipairs(events) do
						if event.control == controls[oldfocusedcontrol] then
							event.callback()
							break
						end
					end
				end
			end
			if newfocusedcontrol > 0 then
				local events = self:geteventhandler("focused")
				if events then
					for _, event in ipairs(events) do
						if event.control == controls[newfocusedcontrol] then
							event.callback()
							break
						end
					end
				end
			end
			self.focusedcontrol = newfocusedcontrol
		end
	end
end
function LOVELi.LayoutManager:mousemoved(x, y, dx, dy, istouch)
	if self:getisenabled() then
		local events = self:geteventhandler("mouseleft")
		if events then
			for _, event in ipairs(events) do
				if event.control:getisvisible() and event.control:getisenabled() then
					local renderwidth = event.control:getrenderwidth()
					local renderheight = event.control:getrenderheight()
					if renderwidth > 0 and renderheight > 0 then
						local renderx = event.control:getrenderx()
						local rendery = event.control:getrendery()
						if not (x >= renderx and x < renderx + renderwidth and y >= rendery and y < rendery + renderheight) and
							 (x - dx >= renderx and x - dx < renderx + renderwidth and y - dy >= rendery and y - dy < rendery + renderheight) then
							event.callback(x, y, dx, dy, istouch)
							break
						end	
					end
				end
			end
		end
		events = self:geteventhandler("mouseentered")
		if events then
			for _, event in ipairs(events) do
				if event.control:getisvisible() and event.control:getisenabled() then
					local renderwidth = event.control:getrenderwidth()
					local renderheight = event.control:getrenderheight()
					if renderwidth > 0 and renderheight > 0 then
						local renderx = event.control:getrenderx()
						local rendery = event.control:getrendery()
						if (x >= renderx and x < renderx + renderwidth and y >= rendery and y < rendery + renderheight) and 
						   not (x - dx >= renderx and x - dx < renderx + renderwidth and y - dy >= rendery and y - dy < rendery + renderheight) then
							event.callback(x, y, dx, dy, istouch)
							break
						end	
					end
				end
			end
		end
		if self.focusedcontrol > 0 then
			local events = self:geteventhandler("mousemoved")
			if events then
				local controls = self:getvisiblecontrols()
				for _, event in ipairs(events) do
					if event.control == controls[self.focusedcontrol] then
						event.callback(x, y , dx, dy, istouch)
						break
					end
				end
			end
		end
	end
end
function LOVELi.LayoutManager:mousereleased(x, y, button, istouch, presses)
	if self:getisenabled() then
		if self.focusedcontrol > 0 then
			local events = self:geteventhandler("mousereleased")
			if events then
				local controls = self:getvisiblecontrols()
				for _, event in ipairs(events) do
					if event.control == controls[self.focusedcontrol] then
						event.callback(x, y, dx, dy, istouch)
						break
					end
				end
			end
		end
	end
end
function LOVELi.LayoutManager:wheelmoved(dx, dy)
	if self:getisenabled() then		
		local events = self:geteventhandler("wheelmoved")
		if events then
			local x, y = love.mouse.getPosition()
			for _, event in ipairs(events) do
				if event.control:getisvisible() and event.control:getisenabled() then
					local renderwidth = event.control:getrenderwidth()
					local renderheight = event.control:getrenderheight()
					if renderwidth > 0 and renderheight > 0 then
						local renderx = event.control:getrenderx()
						local rendery = event.control:getrendery()
						if x >= renderx and x < renderx + renderwidth and y >= rendery and y < rendery + renderheight then
							if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then						
								event.callback(x, y, dy, dx)
							else
								event.callback(x, y, dx, dy)
							end							
							break
						end	
					end
				end
			end
		end
	end
end
function LOVELi.LayoutManager:joystickhat(joystick, hat, direction)
	local key = nil
	if direction == "u" then
		key = "up"
	elseif direction == "d" then
		key = "down"
	elseif direction == "l" then
		key = "left"
	elseif direction == "r" then
		key = "right"
	end
	if key then
		self:keypressed(key, key, false)
	end
end
function LOVELi.LayoutManager:joystickpressed(joystick, button)
	local key = "return"
	self:keypressed(key, key, false)
end
function LOVELi.LayoutManager:resize(width, height)
	self:setwidth(width)
	self:setheight(height)
	self:invalidate()
end
function LOVELi.LayoutManager:init()
	if not self.initialized then
		self.initialized = true
		for _, control in ipairs(self:getcontrols() ) do
			control:init(self)
		end
	end	
end
function LOVELi.LayoutManager:update(dt)
	if self:getisvisible() then
		self:init()
		self.alpha = ( (self.maximumalpha + self.minimumalpha) + (self.maximumalpha - self.minimumalpha) * math.sin(2 * math.pi / self.interval * love.timer.getTime() ) ) / 2
		for _, control in ipairs(self:getvisiblecontrols() ) do
			control:update(dt)
		end
	end
end
function LOVELi.LayoutManager:draw()
	if self:getisvisible() then	
		self:init()
		if self.invalid then
			self.invalid = false
			local screenx = self:getx()
			local screeny = self:gety()
			local screenwidth = self:getwidth()
			local screenheight = self:getheight()
			local viewportx = 0
			local viewporty = 0
			local viewportwidth = love.graphics:getWidth()
			local viewportheight = love.graphics:getHeight()
			local control = self:getrootcontrol()
			control:measure(screenwidth, screenheight)
			control:arrange(
				screenx + control:getx(),
				screeny + control:gety(), 
				control:getdesiredwidth() + control:getmargin():gethorizontal(), 
				control:getdesiredheight() + control:getmargin():getvertical(),
				
				LOVELi.Math.clipx(viewportx, screenx),
				LOVELi.Math.clipy(viewporty, screeny),
				LOVELi.Math.clipwidth(viewportx, viewportwidth, screenx, screenwidth),
				LOVELi.Math.clipheight(viewporty, viewportheight, screeny, screenheight)				
			)
		end
		local controls = self:getvisiblecontrols()
		for _, control in ipairs(controls) do
			control:draw()
		end
		local mode, alphamode = love.graphics.getBlendMode()
		love.graphics.setBlendMode("alpha", "premultiplied")
		for j, control in ipairs(controls) do
			local canvas = control:getcanvas()
			if canvas then
				if self.focusedcontrol == j then
					love.graphics.setColor(self.alpha, self.alpha, self.alpha, self.alpha)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
				love.graphics.draw(canvas, math.floor(control:getrenderx() ), math.floor(control:getrendery() ) ) -- Snap to grid
			end
		end
		love.graphics.setBlendMode(mode, alphamode)
	end
end
function LOVELi.LayoutManager:type()
	return "LayoutManager"
end