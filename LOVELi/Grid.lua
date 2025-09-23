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
	self.availablewidth = availablewidth or self.availablewidth
	self.availableheight = availableheight or self.availableheight
	if availablewidth then
		if availablewidth <= 0 or not self:getisvisible() then
			self.desiredwidth = 0 
			for _, control in ipairs(self:getcontrols() ) do
				control:measure(0, nil)
			end
		else
			if self:getwidth() == "*" then
				self.desiredwidth = math.min(self:getmaxwidth(), math.max(self:getminwidth(), availablewidth - self:getmargin():gethorizontal() ) )
			elseif self:getwidth() == "auto" then
				self.desiredwidth = availablewidth - self:getmargin():gethorizontal()
			else
				self.desiredwidth = self:getwidth() 
			end				
			local widthremaining = self:getdesiredwidth()
			local widthproportions = 0
			for i = 1, #self.columns do
				local column = self.columns[i]
				if type(column:getwidth() ) == "number" then
					for j = 1, #self.rows do
						local controls = self:getcontrol(j, i)
						if controls then
							for _, control in ipairs(controls) do
								control:measure(column:getwidth(), nil)
							end
						end
					end
					column.desiredwidth = column:getwidth()
					widthremaining = widthremaining - column:getdesiredwidth()
				elseif column:getwidth() == "auto" then
					local maxwidth = 0
					local skipped = {}
					for j = 1, #self.rows do
						local controls = self:getcontrol(j, i)
						if controls then
							for _, control in ipairs(controls) do
								if control:getwidth() == "*" then
									table.insert(skipped, control)
								else
									control:measure(math.huge, nil)
									local width = control:getdesiredwidth() + control:getmargin():gethorizontal()
									if width > 0 and control:getisvisible() then
										if width > maxwidth then
											maxwidth = width
										end
									end
								end
							end
						end
					end
					if #skipped > 0 then
						for _, control in ipairs(skipped) do
							control:measure(maxwidth, nil)
						end
					end
					column.desiredwidth = maxwidth
					widthremaining = widthremaining - column:getdesiredwidth()
				else
					if self:getwidth() == "auto" then
						error("Can not use \"*\" width column definition inside an \"auto\" width Grid.")
					end
					local proportion = tonumber(string.sub(column:getwidth(), 1, -2) )
					widthproportions = widthproportions + proportion
				end
			end
			local sumwidth = 0
			for i = 1, #self.columns do
				local column = self.columns[i]
				if type(column:getwidth() ) == "number" then
				elseif column:getwidth() == "auto" then
				else
					local proportion = tonumber(string.sub(column:getwidth(), 1, -2) )
					for j = 1, #self.rows do
						local controls = self:getcontrol(j, i)
						if controls then
							for _, control in ipairs(controls) do
								control:measure(widthremaining * proportion / widthproportions, nil)
							end
						end
					end
					column.desiredwidth = widthremaining * proportion / widthproportions
				end
				column.x = sumwidth
				sumwidth = sumwidth + column:getdesiredwidth()
			end
			if self:getwidth()  == "auto" then			
				self.desiredwidth = sumwidth
			end
		end
	end
	if availableheight then
		if availableheight <= 0 or not self:getisvisible() then
			self.desiredheight = 0 
			for _, control in ipairs(self:getcontrols() ) do
				control:measure(nil, 0)
			end
		else
			if self:getheight() == "*" then
				self.desiredheight = math.min(self:getmaxheight(), math.max(self:getminheight(), availableheight - self:getmargin():getvertical() ) )
			elseif self:getheight() == "auto" then
				self.desiredheight = availableheight - self:getmargin():getvertical()
			else
				self.desiredheight = self:getheight()
			end		
			local heightremaining = self:getdesiredheight()
			local heightproportions = 0
			for j = 1, #self.rows do
				local row = self.rows[j]
				if type(row:getheight() ) == "number" then
					for i = 1, #self.columns do
						local controls = self:getcontrol(j, i)
						if controls then
							for _, control in ipairs(controls) do
								control:measure(nil, row:getheight() )
							end
						end
					end				
					row.desiredheight = row:getheight()
					heightremaining = heightremaining - row:getdesiredheight()
				elseif row:getheight() == "auto" then
					local maxheight = 0
					local skipped = {}
					for i = 1, #self.columns do
						local controls = self:getcontrol(j, i)
						if controls then
							for _, control in ipairs(controls) do
								if control:getheight() == "*" then
									table.insert(skipped, control)
								else
									control:measure(nil, math.huge)
									local height = control:getdesiredheight() + control:getmargin():gethorizontal()
									if height > 0 and control:getisvisible() then
										if height > maxheight then
											maxheight = height
										end
									end
								end
							end
						end
					end
					if #skipped > 0 then
						for _, control in ipairs(skipped) do
							control:measure(nil, maxheight)
						end
					end
					row.desiredheight = maxheight
					heightremaining = heightremaining - row:getdesiredheight()
				else
					if self:getheight() == "auto" then
						error("Can not use \"*\" height row definition inside an \"auto\" height Grid.")
					end
					local proportion = tonumber(string.sub(row:getheight(), 1, -2) )
					heightproportions = heightproportions + proportion
				end
			end
			local sumheight = 0
			for j = 1, #self.rows do
				local row = self.rows[j]
				if type(row:getheight() ) == "number" then
				elseif row:getheight() == "auto" then
				else
					local proportion = tonumber(string.sub(row:getheight(), 1, -2) )
					for i = 1, #self.columns do
						local controls = self:getcontrol(j, i)
						if controls then
							for _, control in ipairs(controls) do
								control:measure(nil, heightremaining * proportion / heightproportions)
							end
						end
					end
					row.desiredheight = heightremaining * proportion / heightproportions
				end
				row.y = sumheight
				sumheight = sumheight + row:getdesiredheight()
			end
			if self:getheight() == "auto" then			
				self.desiredheight = sumheight
			end
		end
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
	for i = 1, #self.columns do
		local column = self.columns[i]
		for j = 1, #self.rows do
			local row = self.rows[j]
			local controls = self:getcontrol(j, i)
			if controls then
				for _, control in ipairs(controls) do
					local horizontalalignment = 0	
					if control:gethorizontaloptions() == "start" then
						horizontalalignment = 0
					elseif control:gethorizontaloptions() == "center" then
						horizontalalignment = column:getdesiredwidth() / 2 - (control:getdesiredwidth() + control:getmargin():gethorizontal() ) / 2
					elseif control:gethorizontaloptions() == "end" then
						horizontalalignment = column:getdesiredwidth() - (control:getdesiredwidth() + control:getmargin():gethorizontal() )
					end
					local verticalalignment = 0		
					if control:getverticaloptions() == "start" then
						verticalalignment = 0
					elseif control:getverticaloptions() == "center" then
						verticalalignment = row:getdesiredheight() / 2 - (control:getdesiredheight() + control:getmargin():getvertical() ) / 2
					elseif control:getverticaloptions() == "end" then
						verticalalignment = row:getdesiredheight() - (control:getdesiredheight() + control:getmargin():getvertical() ) 
					end				
					control:arrange(
						screenx + self:getmargin():getleft() + column:getx() + control:getx() + horizontalalignment,
						screeny + self:getmargin():gettop() + row:gety() + control:gety() + verticalalignment, 
						control:getdesiredwidth() + control:getmargin():gethorizontal(), 
						control:getdesiredheight() + control:getmargin():getvertical(),
						
						LOVELi.Math.clipx(viewportx, screenx + self:getmargin():getleft() + column:getx() ),
						LOVELi.Math.clipy(viewporty, screeny + self:getmargin():gettop() + row:gety() ),
						LOVELi.Math.clipwidth(viewportx, viewportwidth, screenx + self:getmargin():getleft() + column:getx(), column:getdesiredwidth() ),
						LOVELi.Math.clipheight(viewporty, viewportheight, screeny + self:getmargin():gettop() + row:gety(), row:getdesiredheight() )
					)
				end		
			end
		end
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
		for _, row in ipairs(self.rows) do
			love.graphics.line(
				x + self:getmargin():getleft(), 
				y + row:gety() + self:getmargin():gettop(), 
				x + self:getdesiredwidth() + self:getmargin():getleft(), 
				y + row:gety() + self:getmargin():gettop() )
			love.graphics.print(
				row:getheight(),
				x + self:getmargin():getleft(),
				y + row:gety() + self:getmargin():gettop() + row:getdesiredheight() / 2 + love.graphics.getFont():getWidth(tostring(row:getheight() ) ) / 2, 
				math.rad(-90) )
		end
		love.graphics.line(
			x + self:getmargin():getleft(), 
			y + self:getdesiredheight() + self:getmargin():gettop(), 
			x + self:getdesiredwidth() + self:getmargin():getleft(), 
			y + self:getdesiredheight() + self:getmargin():gettop() )
		for _, column in ipairs(self.columns) do
			love.graphics.line(
				x + column:getx() + self:getmargin():getleft(), 
				y + self:getmargin():gettop(), 
				x + column:getx() + self:getmargin():getleft(), 
				y + self:getdesiredheight() + self:getmargin():gettop() )			
			love.graphics.print(
				column:getwidth(),
				x + column:getx() + self:getmargin():getleft() + column:getdesiredwidth() / 2 - love.graphics.getFont():getWidth(tostring(column:getwidth() ) ) / 2, 
				y + self:getmargin():gettop() )
		end
		love.graphics.line(
			x + self:getdesiredwidth() + self:getmargin():getleft(), 
			y + self:getmargin():gettop(), 
			x + self:getdesiredwidth() + self:getmargin():getleft(), 
			y + self:getdesiredheight() + self:getmargin():gettop() )
	end
end
function LOVELi.Grid:type() -- override
	return "Grid"
end