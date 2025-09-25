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

LOVELi.FlexLayout = {}
LOVELi.FlexLayout.__index = LOVELi.FlexLayout
setmetatable(LOVELi.FlexLayout, LOVELi.View)
function LOVELi.FlexLayout:new(options) -- LOVELi.FlexLayout LOVELi.FlexLayout:new( { Union<"row", "column"> direction, Union<"start", "center", "end", "spacebetween", "spacearound", "spaceevenly"> justifycontent, Union<"start", "center", "end", "spacebetween", "spacearound", "spaceevenly"> aligncontent, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Thickness margin, Union<"start", "center", "end"> horizontaloptions, Union<"start", "center", "end"> verticaloptions, string name, bool isvisible, bool isenabled } options)
	local o = LOVELi.View.new(self, options)	
	o.direction = LOVELi.Property.parse(options.direction or "row")
	o.justifycontent = LOVELi.Property.parse(options.justifycontent or "start")
	o.aligncontent = LOVELi.Property.parse(options.aligncontent or "start")
	o.grid = nil -- private
	return o
end
function LOVELi.FlexLayout:getdirection()
	return self.direction:getvalue()
end
function LOVELi.FlexLayout:setdirection(value)
	self.direction:setvalue(value)
end
function LOVELi.FlexLayout:getjustifycontent()
	return self.justifycontent:getvalue()
end
function LOVELi.FlexLayout:setjustifycontent(value)
	self.justifycontent:setvalue(value)
end
function LOVELi.FlexLayout:getaligncontent()
	return self.aligncontent:getvalue()
end
function LOVELi.FlexLayout:setaligncontent(value)
	self.aligncontent:setvalue(value)
end
function LOVELi.FlexLayout:with(control)
	if control.parent then
		error("Control's parent is already set.")
	end
	control.parent = self
	table.insert(self.controls, control)
	return self
end
function LOVELi.FlexLayout:measure(availablewidth, availableheight) -- override
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
	local desiredwidth = 0
	local desiredheight = 0
	local remainingwidth = self:getdesiredwidth()
	local remainingheight = self:getdesiredheight()	
	self.grid = {
		summaxheight = 0,
		visiblerows = 0,
		rows = {}
	}
	local row = 1
	local column = 1	
	local visiblerows = 0
	local visiblecolumns = 0
	if self:getdirection() == "row" then
		local sumwidth = 0
		local maxheight = 0	
		for _, control in ipairs(self:getcontrols() ) do
			if control:getwidth() == "*" and self:getwidth() == "auto" then
				error("Can not use \"*\" width control inside an \"auto\" width FlexLayout.")
			end
			if control:getheight() == "*" and self:getheight() == "auto" then
				error("Can not use \"*\" height control inside an \"auto\" height FlexLayout.")
			end		
			control:measure(math.max(0, remainingwidth), math.max(0, remainingheight) )
			local width = 0
			local height = 0
			if control:getisvisible() then
				width = control:getdesiredwidth() + control:getmargin():gethorizontal()
				height = control:getdesiredheight() + control:getmargin():getvertical()				
			end
			if column > 1 and width > remainingwidth then
				--
				self.grid.rows[row].sumwidth = sumwidth
				self.grid.rows[row].maxheight = maxheight
				self.grid.rows[row].visiblecolumns = visiblecolumns
				if sumwidth > desiredwidth then
					desiredwidth = sumwidth
				end
				desiredheight = desiredheight + maxheight
				if visiblecolumns > 0 then
					visiblerows = visiblerows + 1
				end
				--
				row = row + 1
				column = 1
				remainingwidth = self:getdesiredwidth()
				remainingheight = remainingheight - maxheight
				sumwidth = 0
				maxheight = 0
				visiblecolumns = 0
				control:measure(math.max(0, remainingwidth), math.max(0, remainingheight) )
				width = 0
				height = 0
				if control:getisvisible() then
					width = control:getdesiredwidth() + control:getmargin():gethorizontal()
					height = control:getdesiredheight() + control:getmargin():getvertical()
				end	
			end
			if not self.grid.rows[row] then
				self.grid.rows[row] = {
					sumwidth = 0,
					maxheight = 0,
					visiblecolumns = 0,
					columns = {}
				}
			end
			self.grid.rows[row].columns[column] = control
			sumwidth = sumwidth + width
			if height > maxheight then
				maxheight = height
			end
			if control:getisvisible() then
				visiblecolumns = visiblecolumns + 1
			end
			column = column + 1
			remainingwidth = remainingwidth - width
		end
		--
		self.grid.rows[row].sumwidth = sumwidth
		self.grid.rows[row].maxheight = maxheight
		self.grid.rows[row].visiblecolumns = visiblecolumns
		if sumwidth > desiredwidth then
			desiredwidth = sumwidth
		end
		desiredheight = desiredheight + maxheight
		if visiblecolumns > 0 then
			visiblerows = visiblerows + 1
		end
		--
		self.grid.summaxheight = desiredheight
		self.grid.visiblerows = visiblerows
	else
		local sumheight = 0
		local maxwidth = 0
		for _, control in ipairs(self:getcontrols() ) do
			if control:getwidth() == "*" and self:getwidth() == "auto" then
				error("Can not use \"*\" width control inside an \"auto\" width FlexLayout.")
			end
			if control:getheight() == "*" and self:getheight() == "auto" then
				error("Can not use \"*\" height control inside an \"auto\" height FlexLayout.")
			end		
			control:measure(math.max(0, remainingwidth), math.max(0, remainingheight) )
			local width = 0
			local height = 0
			if control:getisvisible() then
				width = control:getdesiredwidth() + control:getmargin():gethorizontal()
				height = control:getdesiredheight() + control:getmargin():getvertical()				
			end
			if column > 1 and height > remainingheight then
				--
				self.grid.rows[row].sumheight = sumheight
				self.grid.rows[row].maxwidth = maxwidth
				self.grid.rows[row].visiblecolumns = visiblecolumns
				desiredwidth = desiredwidth + maxwidth
				if sumheight > desiredheight then
					desiredheight = sumheight
				end
				if visiblecolumns > 0 then
					visiblerows = visiblerows + 1
				end
				--
				row = row + 1
				column = 1
				remainingheight = self:getdesiredheight()
				remainingwidth = remainingwidth - maxwidth
				sumheight = 0
				maxwidth = 0
				visiblecolumns = 0
				control:measure(math.max(0, remainingwidth), math.max(0, remainingheight) )
				width = 0
				height = 0
				if control:getisvisible() then
					width = control:getdesiredwidth() + control:getmargin():gethorizontal()
					height = control:getdesiredheight() + control:getmargin():getvertical()
				end
			end
			if not self.grid.rows[row] then
				self.grid.rows[row] = {
					sumheight = 0,
					maxwidth = 0,
					visiblecolumns = 0,
					columns = {}
				}
			end
			self.grid.rows[row].columns[column] = control
			sumheight = sumheight + height
			if width > maxwidth then
				maxwidth = width
			end			
			if control:getisvisible() then
				visiblecolumns = visiblecolumns + 1
			end
			column = column + 1
			remainingheight = remainingheight - height
		end
		--
		self.grid.rows[row].sumheight = sumheight
		self.grid.rows[row].maxwidth = maxwidth
		self.grid.rows[row].visiblecolumns = visiblecolumns
		desiredwidth = desiredwidth + maxwidth
		if sumheight > desiredheight then
			desiredheight = sumheight
		end
		if visiblecolumns > 0 then
			visiblerows = visiblerows + 1
		end
		--
		self.grid.summaxwidth = desiredwidth
		self.grid.visiblerows = visiblerows
	end
	if self:getwidth() == "auto" then
		self.desiredwidth = desiredwidth
	end
	if self:getheight() == "auto" then
		self.desiredheight = desiredheight
	end
end
function LOVELi.FlexLayout:arrange(screenx, screeny, screenwidth, screenheight, viewportx, viewporty, viewportwidth, viewportheight) -- override
	self.screenx = screenx
	self.screeny = screeny
	self.screenwidth = screenwidth
	self.screenheight = screenheight
	self.viewportx = viewportx
	self.viewporty = viewporty
	self.viewportwidth = viewportwidth
	self.viewportheight = viewportheight
	if self:getdirection() == "row" then
		local offsetx = 0
		local offsety = 0
		--       column 1  column 2
		-- row 1 control 1 control 2
		-- row 2 control 3 control 4
		local j = 1
		for _, row in ipairs(self.grid.rows) do
			local aligncontent
			if self:getaligncontent() == "start" then
				aligncontent = 0
			elseif self:getaligncontent() == "center" then
				aligncontent = ( self:getdesiredheight() - self.grid.summaxheight ) / 2
			elseif self:getaligncontent() == "end" then
				aligncontent = self:getdesiredheight() - self.grid.summaxheight
			elseif self:getaligncontent() == "spacebetween" then	
				aligncontent = ( (self:getdesiredheight() - self.grid.summaxheight) / (self.grid.visiblerows - 1) ) * (j - 1)
			elseif self:getaligncontent() == "spacearound" then
				aligncontent = ( (self:getdesiredheight() - self.grid.summaxheight) / (self.grid.visiblerows * 2) ) * (j * 2 - 1)
			elseif self:getaligncontent() == "spaceevenly" then
				aligncontent = ( (self:getdesiredheight() - self.grid.summaxheight) / (self.grid.visiblerows + 1) ) * j
			end
			local i = 1
			for _, control in ipairs(row.columns) do
				local justifycontent
				if self:getjustifycontent() == "start" then
					justifycontent = 0
				elseif self:getjustifycontent() == "center" then
					justifycontent = ( self:getdesiredwidth() - row.sumwidth ) / 2
				elseif self:getjustifycontent() == "end" then
					justifycontent = self:getdesiredwidth() - row.sumwidth
				elseif self:getjustifycontent() == "spacebetween" then	
					justifycontent = ( (self:getdesiredwidth() - row.sumwidth) / (row.visiblecolumns - 1) ) * (i - 1)
				elseif self:getjustifycontent() == "spacearound" then
					justifycontent = ( (self:getdesiredwidth() - row.sumwidth) / (row.visiblecolumns * 2) ) * (i * 2 - 1)
				elseif self:getjustifycontent() == "spaceevenly" then
					justifycontent = ( (self:getdesiredwidth() - row.sumwidth) / (row.visiblecolumns + 1) ) * i
				end
				local verticalalignment
				if control:getverticaloptions() == "start" then
					verticalalignment = 0
				elseif control:getverticaloptions() == "center" then
					verticalalignment = ( row.maxheight - (control:getdesiredheight() + control:getmargin():getvertical() ) ) / 2
				elseif control:getverticaloptions() == "end" then
					verticalalignment = row.maxheight - (control:getdesiredheight() + control:getmargin():getvertical() ) 
				end	
				control:arrange(
					screenx + self:getmargin():getleft() + control:getx() + offsetx + justifycontent,
					screeny + self:getmargin():gettop() + control:gety() + offsety + aligncontent + verticalalignment, 
					control:getdesiredwidth() + control:getmargin():gethorizontal(), 
					control:getdesiredheight() + control:getmargin():getvertical(),
					
					LOVELi.Math.clipx(viewportx, screenx + self:getmargin():getleft() ),
					LOVELi.Math.clipy(viewporty, screeny + self:getmargin():gettop() ),
					LOVELi.Math.clipwidth(viewportx, viewportwidth, screenx + self:getmargin():getleft(), self:getdesiredwidth() ),
					LOVELi.Math.clipheight(viewporty, viewportheight, screeny + self:getmargin():gettop(), self:getdesiredheight() )				
				)				
				if control:getisvisible() then
					offsetx = offsetx + control:getdesiredwidth() + control:getmargin():gethorizontal()
					i = i + 1
				end
			end
			offsetx = 0
			offsety = offsety + row.maxheight
			if i > 1 then
				j = j + 1
			end
		end
	else
		local offsetx = 0
		local offsety = 0
		--          row 1     row 2
		-- column 1 control 1 control 3
		-- column 2 control 2 control 4
		local j = 1
		for _, row in ipairs(self.grid.rows) do
			local aligncontent
			if self:getaligncontent() == "start" then
				aligncontent = 0
			elseif self:getaligncontent() == "center" then
				aligncontent = ( self:getdesiredwidth() - self.grid.summaxwidth ) / 2
			elseif self:getaligncontent() == "end" then
				aligncontent = self:getdesiredwidth() - self.grid.summaxwidth
			elseif self:getaligncontent() == "spacebetween" then	
				aligncontent = ( (self:getdesiredwidth() - self.grid.summaxwidth) / (self.grid.visiblerows - 1) ) * (j - 1)
			elseif self:getaligncontent() == "spacearound" then
				aligncontent = ( (self:getdesiredwidth() - self.grid.summaxwidth) / (self.grid.visiblerows * 2) ) * (j * 2 - 1)
			elseif self:getaligncontent() == "spaceevenly" then
				aligncontent = ( (self:getdesiredwidth() - self.grid.summaxwidth) / (self.grid.visiblerows + 1) ) * j
			end
			local i = 1
			for _, control in ipairs(row.columns) do
				local justifycontent
				if self:getjustifycontent() == "start" then
					justifycontent = 0
				elseif self:getjustifycontent() == "center" then
					justifycontent = ( self:getdesiredheight() - row.sumheight ) / 2
				elseif self:getjustifycontent() == "end" then
					justifycontent = self:getdesiredheight() - row.sumheight
				elseif self:getjustifycontent() == "spacebetween" then	
					justifycontent = ( (self:getdesiredheight() - row.sumheight) / (row.visiblecolumns - 1) ) * (i - 1)
				elseif self:getjustifycontent() == "spacearound" then
					justifycontent = ( (self:getdesiredheight() - row.sumheight) / (row.visiblecolumns * 2) ) * (i * 2 - 1)
				elseif self:getjustifycontent() == "spaceevenly" then
					justifycontent = ( (self:getdesiredheight() - row.sumheight) / (row.visiblecolumns + 1) ) * i
				end
				local horizontalalignment
				if control:gethorizontaloptions() == "start" then
					horizontalalignment = 0
				elseif control:gethorizontaloptions() == "center" then
					horizontalalignment = ( row.maxwidth - (control:getdesiredwidth() + control:getmargin():gethorizontal() ) ) / 2
				elseif control:gethorizontaloptions() == "end" then
					horizontalalignment = row.maxwidth - (control:getdesiredwidth() + control:getmargin():gethorizontal() ) 
				end
				control:arrange(
					screenx + self:getmargin():getleft() + control:getx() + offsetx + aligncontent + horizontalalignment,
					screeny + self:getmargin():gettop() + control:gety() + offsety + justifycontent, 
					control:getdesiredwidth() + control:getmargin():gethorizontal(), 
					control:getdesiredheight() + control:getmargin():getvertical(),
					
					LOVELi.Math.clipx(viewportx, screenx + self:getmargin():getleft() ),
					LOVELi.Math.clipy(viewporty, screeny + self:getmargin():gettop() ),
					LOVELi.Math.clipwidth(viewportx, viewportwidth, screenx + self:getmargin():getleft(), self:getdesiredwidth() ),
					LOVELi.Math.clipheight(viewporty, viewportheight, screeny + self:getmargin():gettop(), self:getdesiredheight() )				
				)				
				if control:getisvisible() then
					offsety = offsety + control:getdesiredheight() + control:getmargin():getvertical()
					i = i + 1
				end
			end
			offsety = 0
			offsetx = offsetx + row.maxwidth
			if i > 1 then
				j = j + 1
			end
		end
	end
end
function LOVELi.FlexLayout:type() -- override
	return "FlexLayout"
end