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

LOVELi.Property = {}
LOVELi.Property.__index = LOVELi.Property
function LOVELi.Property:new(value) -- LOVELi.Property LOVELi.Property:new(object value)
	local o = { 
		value = value
	}	
	setmetatable(o, self)
	return o
end
function LOVELi.Property:getvalue()
	return self.value
end
function LOVELi.Property:setvalue(value)
	self.value = value
end
function LOVELi.Property:type()
	return "Property"
end
function LOVELi.Property.parse(value) -- static
	if type(value) == "table" and value.type and value:type() == "Property" then
		return value
	end
	return LOVELi.Property:new(value)	
end