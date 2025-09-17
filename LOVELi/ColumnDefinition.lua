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

LOVELi.ColumnDefinition = {}
LOVELi.ColumnDefinition.__index = LOVELi.ColumnDefinition
function LOVELi.ColumnDefinition:new(width) -- LOVELi.ColumnDefinition LOVELi.ColumnDefinition:new(Union<"1*", "2*", ..., "auto", int> width)
	local o = {
		width = width,
		x = nil,
		desiredwidth = nil
	}
	setmetatable(o, self)
	return o
end
function LOVELi.ColumnDefinition:getwidth()
	return self.width
end
function LOVELi.ColumnDefinition:getx()
	return self.x
end
function LOVELi.ColumnDefinition:getdesiredwidth()
	return self.desiredwidth
end
function LOVELi.ColumnDefinition:type()
	return "ColumnDefinition"
end