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

LOVELi.Color = {}
LOVELi.Color.__index = LOVELi.Color
function LOVELi.Color:new(red, green, blue, alpha) -- LOVELi.Color LOVELi.Color:new(float red = 0, float green = 0, float blue = 0, float alpha = 1)
	local o = { 
		red = red or 0, 
		green = green or 0, 
		blue = blue or 0, 
		alpha = alpha or 1
	}	
	setmetatable(o, self)
	return o
end
function LOVELi.Color:getred()
	return self.red
end
function LOVELi.Color:getgreen()
	return self.green
end
function LOVELi.Color:getblue()
	return self.blue
end
function LOVELi.Color:getalpha()
	return self.alpha
end
function LOVELi.Color:getrgba()
	return self.red, self.green, self.blue, self.alpha
end	
function LOVELi.Color:type()
	return "Color"
end
function LOVELi.Color.parse(value) -- static
	local red
	local green
	local blue
	local alpha
	if type(value) == "number" then
		red = (math.floor(value / 16777216) % 256) / 255
		green = (math.floor(value / 65536) % 256) / 255
		blue = (math.floor(value / 256) % 256) / 255 
		alpha = (value % 256) / 255
	elseif type(value) == "string" then
		if value == "red" then
			red = 1
		elseif value == "green" then
			green = 1
		elseif value == "blue" then
			blue = 1
		elseif value == "yellow" then
			red = 1
			green = 1
		elseif value == "cyan" then
			green = 1
			blue = 1
		elseif value == "magenta" then
			red = 1
			blue = 1
		elseif value == "gray" then
			red = 0.5
			green = 0.5
			alpha = 0.5
		elseif value == "white" then
			red = 1
			green = 1
			blue = 1
		end
	elseif type(value) == "table" then
		red = value.red
		green = value.green
		blue = value.blue
		alpha = value.alpha	
	end
	return LOVELi.Color:new(red, green, blue, alpha)
end