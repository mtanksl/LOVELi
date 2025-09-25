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

LOVELi.Grid = {}
LOVELi.Grid.__index = LOVELi.Grid
setmetatable(LOVELi.Grid, LOVELi.View)
function LOVELi.Grid:new(options) -- LOVELi.Grid LOVELi.Grid:new( { Union<"1*", "2*", ... "auto", int>[] rowdefinitions, Union<"1*", "2*", ..., "auto", int>[] columndefinitions, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)
	o.rows = {}	
	for _, rowdefinition in ipairs(options.rowdefinitions) do
		o:addrow(rowdefinition)
	end
	o.columns = {}
	for _, columndefinition in ipairs(options.columndefinitions) do
		o:addcolumn(columndefinition)
	end
	o.grid = {}
	return o
end
function LOVELi.Grid:getrows()
	return self.rows
end
function LOVELi.Grid:getcolumns()
	return self.columns
end
function LOVELi.Grid:getcontrol(row, column)
	if self.grid[row] then
		return self.grid[row][column]
	end
	return nil
end
function LOVELi.Grid:with(row, column, control)
	if control.parent then
		error("Control's parent is already set.")
	end
	control.parent = self
	table.insert(self.controls, control)
	if not self.grid[row] then
		self.grid[row] = {}
	end
	if not self.grid[row][column] then
		self.grid[row][column] = {}
	end
	table.insert(self.grid[row][column], control)
	return self
end
function LOVELi.Grid:addrow(height)
	table.insert(self.rows, LOVELi.RowDefinition:new(height) )
end
function LOVELi.Grid:addcolumn(width)
	table.insert(self.columns,  LOVELi.ColumnDefinition:new(width) )
end
function LOVELi.Grid:measure(availablewidth, availableheight) -- override
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
	-- start	
	local proportionswidth = 0
	for i = 1, #self.columns do
		local column = self.columns[i]
		if type(column:getwidth() ) == "number" then
		elseif column:getwidth() == "auto" then
		else
			if self:getwidth() == "auto" then
				error("Can not use \"*\" width column definition inside an \"auto\" width Grid.")
			end
			local proportionwidth = tonumber(string.sub(column:getwidth(), 1, -2) )
			proportionswidth = proportionswidth + proportionwidth
		end
		column.desiredwidth = 0
	end
	local proportionsheight = 0
	for j = 1, #self.rows do
		local row = self.rows[j]
		if type(row:getheight() ) == "number" then
		elseif row:getheight() == "auto" then
		else
			if self:getheight() == "auto" then
				error("Can not use \"*\" height column definition inside an \"auto\" height Grid.")
			end
			local proportionheight = tonumber(string.sub(row:getheight(), 1, -2) )
			proportionsheight = proportionsheight + proportionheight
		end
		row.desiredheight = 0
	end
	-- number x number
	for i = 1, #self.columns do
		local column = self.columns[i]
		if type(column:getwidth() ) == "number" then
			for j = 1, #self.rows do
				local row = self.rows[j]
				if type(row:getheight() ) == "number" then
					local controls = self:getcontrol(j, i)
					if controls then
						for _, control in ipairs(controls) do
							control:measure(column:getwidth(), row:getheight() )
						end
					end
					row.desiredheight = row:getheight()
				end
			end
			column.desiredwidth = column:getwidth()
		end
	end
	-- number x auto
	for i = 1, #self.columns do
		local column = self.columns[i]
		if type(column:getwidth() ) == "number" then
			for j = 1, #self.rows do
				local row = self.rows[j]
				if row:getheight() == "auto" then
					local maxheight = 0
					local controls = self:getcontrol(j, i)
					if controls then
						for _, control in ipairs(controls) do
							if control:getheight() == "*" then
								error("Can not use \"*\" height control inside an \"auto\" height column definition.")
							end
							control:measure(column:getwidth(), math.huge)
							if control:getisvisible() then
								local height = control:getdesiredheight() + control:getmargin():getvertical()
								if height > maxheight then
									maxheight = height
								end
							end
						end
					end
					row.desiredheight = math.max(row:getdesiredheight(), maxheight)
				end
			end
			column.desiredwidth = column:getwidth()
		end
	end
	-- auto x number
	for i = 1, #self.columns do
		local column = self.columns[i]
		if column:getwidth() == "auto" then
			local maxwidth = 0
			for j = 1, #self.rows do
				local row = self.rows[j]
				if type(row:getheight() ) == "number" then
					local controls = self:getcontrol(j, i)
					if controls then
						for _, control in ipairs(controls) do
							if control:getwidth() == "*" then
								error("Can not use \"*\" width control inside an \"auto\" width column definition.")
							end
							control:measure(math.huge, row:getheight() )
							if control:getisvisible() then
								local width = control:getdesiredwidth() + control:getmargin():gethorizontal()
								if width > maxwidth then
									maxwidth = width
								end
							end
						end
					end
					row.desiredheight = row:getheight()
				end
			end
			column.desiredwidth = math.max(column:getdesiredwidth(), maxwidth)
		end
	end
	-- auto x auto
	for i = 1, #self.columns do
		local column = self.columns[i]
		if column:getwidth() == "auto" then
			local maxwidth = 0
			for j = 1, #self.rows do
				local row = self.rows[j]
				if row:getheight() == "auto" then
					local maxheight = 0
					local controls = self:getcontrol(j, i)
					if controls then
						for _, control in ipairs(controls) do							
							if control:getwidth() == "*" then
								error("Can not use \"*\" width control inside an \"auto\" width column definition.")
							end
							if control:getheight() == "*" then
								error("Can not use \"*\" height control inside an \"auto\" height column definition.")
							end
							control:measure(math.huge, math.huge)
							if control:getisvisible() then
								local width = control:getdesiredwidth() + control:getmargin():gethorizontal()
								if width > maxwidth then
									maxwidth = width
								end
								local height = control:getdesiredheight() + control:getmargin():getvertical()
								if height > maxheight then
									maxheight = height
								end
							end
						end
					end
					row.desiredheight = math.max(row:getdesiredheight(), maxheight)
				end
			end
			column.desiredwidth = math.max(column:getdesiredwidth(), maxwidth)
		end
	end
	-- remaining
	if proportionswidth > 0 or proportionsheight > 0 then
		local remainingwidth
		local remainingheight
		local calculatewidth = true
		local calculateheight = true
		while true do			
			if calculatewidth then
				calculatewidth = false
				remainingwidth = self:getdesiredwidth()
				for i = 1, #self.columns do
					local column = self.columns[i]
					if type(column:getwidth() ) == "number" or column:getwidth() == "auto" then
						remainingwidth = remainingwidth - column:getdesiredwidth()
					end
				end
				-- * x auto
				for i = 1, #self.columns do
					local column = self.columns[i]
					if type(column:getwidth() ) == "number" then
					elseif column:getwidth() == "auto" then	
					else
						local proportionwidth = tonumber(string.sub(column:getwidth(), 1, -2) )
						for j = 1, #self.rows do
							local row = self.rows[j]
							if row:getheight() == "auto" then
								local maxheight = 0
								local controls = self:getcontrol(j, i)
								if controls then
									for _, control in ipairs(controls) do
										if control:getheight() == "*" then
											error("Can not use \"*\" height control inside an \"auto\" height column definition.")
										end
										control:measure(math.max(0, remainingwidth * proportionwidth / proportionswidth), math.huge)
										if control:getisvisible() then
											local height = control:getdesiredheight() + control:getmargin():getvertical()
											if height > maxheight then
												maxheight = height
											end
										end
									end
								end
								if maxheight > row:getdesiredheight() then
									calculateheight = true
									row.desiredheight = maxheight
								end
							end
						end
						column.desiredwidth = math.max(0, remainingwidth * proportionwidth / proportionswidth)
					end
				end
			end
			if calculateheight then
				calculateheight = false
				remainingheight = self:getdesiredheight()
				for j = 1, #self.rows do
					local row = self.rows[j]
					if type(row:getheight() ) == "number" or row:getheight() == "auto" then
						remainingheight = remainingheight - row:getdesiredheight()
					end
				end
				-- auto x *
				for i = 1, #self.columns do
					local column = self.columns[i]
					if column:getwidth() == "auto" then
						local maxwidth = 0
						for j = 1, #self.rows do
							local row = self.rows[j]
							if type(row:getheight() ) == "number" then
							elseif row:getheight() == "auto" then
							else	
								local proportionheight = tonumber(string.sub(row:getheight(), 1, -2) )
								local controls = self:getcontrol(j, i)
								if controls then
									for _, control in ipairs(controls) do
										if control:getwidth() == "*" then
											error("Can not use \"*\" width control inside an \"auto\" width column definition.")
										end
										control:measure(math.huge, math.max(0, remainingheight * proportionheight / proportionsheight) )
										if control:getisvisible() then
											local width = control:getdesiredwidth() + control:getmargin():gethorizontal()
											if width > maxwidth then
												maxwidth = width
											end
										end
									end
								end
								row.desiredheight = math.max(0, remainingheight * proportionheight / proportionsheight)
							end
						end
						if maxwidth > column:getdesiredwidth() then
							calculatewidth = true
							column.desiredwidth = maxwidth
						end
					end
				end
			end
			if not calculatewidth and not calculateheight then
				break
			end
		end	
		-- * x number
		for i = 1, #self.columns do
			local column = self.columns[i]
			if type(column:getwidth() ) == "number" then
			elseif column:getwidth() == "auto" then	
			else
				local proportionwidth = tonumber(string.sub(column:getwidth(), 1, -2) )
				for j = 1, #self.rows do
					local row = self.rows[j]
					if type(row:getheight() ) == "number" then
						local controls = self:getcontrol(j, i)
						if controls then
							for _, control in ipairs(controls) do
								control:measure(math.max(0, remainingwidth * proportionwidth / proportionswidth), row:getheight() )
							end
						end
						row.desiredheight = row:getheight()
					end
				end
				column.desiredwidth = math.max(0, remainingwidth * proportionwidth / proportionswidth)
			end
		end		
		-- number x *
		for i = 1, #self.columns do
			local column = self.columns[i]
			if type(column:getwidth() ) == "number" then
				for j = 1, #self.rows do
					local row = self.rows[j]
					if type(row:getheight() ) == "number" then
					elseif row:getheight() == "auto" then
					else	
						local proportionheight = tonumber(string.sub(row:getheight(), 1, -2) )
						local controls = self:getcontrol(j, i)
						if controls then
							for _, control in ipairs(controls) do
								control:measure(column:getwidth(), math.max(0, remainingheight * proportionheight / proportionsheight) )
							end
						end
						row.desiredheight = math.max(0, remainingheight * proportionheight / proportionsheight)
					end
				end
				column.desiredwidth = column:getwidth()
			end
		end
		-- * x *
		for i = 1, #self.columns do
			local column = self.columns[i]
			if type(column:getwidth() ) == "number" then
			elseif column:getwidth() == "auto" then	
			else
				local proportionwidth = tonumber(string.sub(column:getwidth(), 1, -2) )
				for j = 1, #self.rows do
					local row = self.rows[j]
					if type(row:getheight() ) == "number" then
					elseif row:getheight() == "auto" then
					else	
						local proportionheight = tonumber(string.sub(row:getheight(), 1, -2) )
						local controls = self:getcontrol(j, i)
						if controls then
							for _, control in ipairs(controls) do
								control:measure(math.max(0,remainingwidth * proportionwidth / proportionswidth), math.max(0,remainingheight * proportionheight / proportionsheight) )
							end
						end
						row.desiredheight = math.max(0,remainingheight * proportionheight / proportionsheight)
					end
				end
				column.desiredwidth = math.max(0, remainingwidth * proportionwidth / proportionswidth)
			end
		end
	end
	-- end
	if self:getwidth() == "auto" then
		local desiredwidth = 0
		for i = 1, #self.columns do
			desiredwidth = desiredwidth + column:getdesiredwith()
		end	
		self.desiredwidth = desiredwidth
	end
	if self:getheight() == "auto" then
		local desiredheight = 0
		for j = 1, #self.rows do
			desiredheight = desiredheight + row:getdesiredheight()
		end
		self.desiredheight = desiredheight
	end
end
function LOVELi.Grid:arrange(screenx, screeny, screenwidth, screenheight, viewportx, viewporty, viewportwidth, viewportheight) -- override
	self.screenx = screenx
	self.screeny = screeny
	self.screenwidth = screenwidth
	self.screenheight = screenheight
	self.viewportx = viewportx
	self.viewporty = viewporty
	self.viewportwidth = viewportwidth
	self.viewportheight = viewportheight
	local offsetx =  0
	for i = 1, #self.columns do
		local column = self.columns[i]
		local offsety =  0
		for j = 1, #self.rows do
			local row = self.rows[j]
			local controls = self:getcontrol(j, i)
			if controls then
				for _, control in ipairs(controls) do
					local horizontalalignment = 0	
					if control:gethorizontaloptions() == "start" then
						horizontalalignment = 0
					elseif control:gethorizontaloptions() == "center" then
						horizontalalignment = ( column:getdesiredwidth() - (control:getdesiredwidth() + control:getmargin():gethorizontal() ) ) / 2
					elseif control:gethorizontaloptions() == "end" then
						horizontalalignment = column:getdesiredwidth() - (control:getdesiredwidth() + control:getmargin():gethorizontal() )
					end
					local verticalalignment = 0		
					if control:getverticaloptions() == "start" then
						verticalalignment = 0
					elseif control:getverticaloptions() == "center" then
						verticalalignment = ( row:getdesiredheight() - (control:getdesiredheight() + control:getmargin():getvertical() ) ) / 2
					elseif control:getverticaloptions() == "end" then
						verticalalignment = row:getdesiredheight() - (control:getdesiredheight() + control:getmargin():getvertical() ) 
					end				
					control:arrange(
						screenx + self:getmargin():getleft() + offsetx + control:getx() + horizontalalignment,
						screeny + self:getmargin():gettop() + offsety + control:gety() + verticalalignment, 
						control:getdesiredwidth() + control:getmargin():gethorizontal(), 
						control:getdesiredheight() + control:getmargin():getvertical(),
						
						LOVELi.Math.clipx(viewportx, screenx + self:getmargin():getleft() + offsetx ),
						LOVELi.Math.clipy(viewporty, screeny + self:getmargin():gettop() + offsety ),
						LOVELi.Math.clipwidth(viewportx, viewportwidth, screenx + self:getmargin():getleft() + offsetx, column:getdesiredwidth() ),
						LOVELi.Math.clipheight(viewporty, viewportheight, screeny + self:getmargin():gettop() + offsety, row:getdesiredheight() )
					)
				end		
			end
			offsety = offsety + row:getdesiredheight()
		end
		offsetx = offsetx + column:getdesiredwidth()
	end
end
function LOVELi.Grid:render(x, y) -- override
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
		local offsety = 0
		for _, row in ipairs(self.rows) do
			if row:getdesiredheight() > 0 then
				love.graphics.line(
					x + self:getmargin():getleft(), 
					y + offsety + self:getmargin():gettop(), 
					x + self:getdesiredwidth() + self:getmargin():getleft(), 
					y + offsety + self:getmargin():gettop() )
				love.graphics.print(
					row:getheight(),
					x + self:getmargin():getleft(),
					y + offsety + self:getmargin():gettop() + (row:getdesiredheight() + love.graphics.getFont():getWidth(tostring(row:getheight() ) ) ) / 2, 
					math.rad(-90) )
				offsety = offsety + row:getdesiredheight()
			end
		end
		love.graphics.line(
			x + self:getmargin():getleft(), 
			y + offsety + self:getmargin():gettop(), 
			x + self:getdesiredwidth() + self:getmargin():getleft(), 
			y + offsety + self:getmargin():gettop() )
		local offsetx = 0
		for _, column in ipairs(self.columns) do
			if column:getdesiredwidth() > 0 then
				love.graphics.line(
					x + offsetx + self:getmargin():getleft(), 
					y + self:getmargin():gettop(), 
					x + offsetx + self:getmargin():getleft(), 
					y + self:getdesiredheight() + self:getmargin():gettop() )			
				love.graphics.print(
					column:getwidth(),
					x + offsetx + self:getmargin():getleft() + (column:getdesiredwidth() - love.graphics.getFont():getWidth(tostring(column:getwidth() ) ) ) / 2, 
					y + self:getmargin():gettop() )
				offsetx = offsetx + column:getdesiredwidth()
			end
		end
		love.graphics.line(
			x + offsetx + self:getmargin():getleft(), 
			y + self:getmargin():gettop(), 
			x + offsetx + self:getmargin():getleft(), 
			y + self:getdesiredheight() + self:getmargin():gettop() )
	end
end
function LOVELi.Grid:type() -- override
	return "Grid"
end