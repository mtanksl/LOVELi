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

LOVELi.Math = {} -- static
function LOVELi.Math.clipx(left1, left2) -- static
	return math.max(left1, left2)
end
function LOVELi.Math.clipy(top1, top2) -- static
	return math.max(top1, top2)
end
function LOVELi.Math.clipwidth(left1, width1, left2, width2) -- static
	local right1 = left1 + width1
	local right2 = left2 + width2
	return math.min(right1, right2) - math.max(left1, left2)
end
function LOVELi.Math.clipheight(top1, height1, top2, height2) -- static
	local bottom1 = top1 + height1
	local bottom2 = top2 + height2
	return math.min(bottom1, bottom2) - math.max(top1, top2)
end