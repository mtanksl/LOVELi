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

LOVELi.Thickness = {}
LOVELi.Thickness.__index = LOVELi.Thickness
function LOVELi.Thickness:new(left, top, right, bottom) -- LOVELi.Thickness LOVELi.Thickness:new(int left = 0, int top = 0, int right = 0, int bottom = 0)
	local o = { 
		left = left or 0, 
		top = top or 0, 
		right = right or 0, 
		bottom = bottom or 0
	}	
	setmetatable(o, self)
	return o
end
function LOVELi.Thickness:getleft()
	return self.left
end
function LOVELi.Thickness:gettop()
	return self.top
end
function LOVELi.Thickness:getright()
	return self.right
end
function LOVELi.Thickness:getbottom()
	return self.bottom
end
function LOVELi.Thickness:gethorizontal()
	return self.left + self.right
end
function LOVELi.Thickness:getvertical()
	return self.top + self.bottom
end
function LOVELi.Thickness:type()
	return "Thickness"
end
function LOVELi.Thickness.parse(value) -- static
	local left
	local top
	local right
	local bottom
	if type(value) == "number" then
		left = value
		top = value
		right = value
		bottom = value
	elseif type(value) == "table" then
		left = value.left
		top = value.top
		right = value.right
		bottom = value.bottom
	elseif type(value) == "string" then
		left, 
		top, 
		right, 
		bottom = string.match(value, "(%d+),(%d+),(%d+),(%d+)")
	end
	return LOVELi.Thickness:new(left, top, right, bottom)
end