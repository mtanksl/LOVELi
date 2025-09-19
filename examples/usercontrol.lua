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

local loveli = require("LOVELi")
function card(width, height, title, text)
	return loveli.Border:new{ width = width, height = height, backgroundcolor = loveli.Color.parse(0xFFFFFFFF) } 
		:with(loveli.StackLayout:new{ orientation = "vertical", width = "*", height = height }
			:with(loveli.Border:new{ padding = loveli.Thickness.parse(10), width = "*", height = "auto" } 
				:with(loveli.Label:new{ text = title, font = love.graphics.newFont(18), width = "*", height = "auto" } )
			)
			:with(loveli.Border:new{ padding = loveli.Thickness.parse(10), width = "*", height = "*" } 
				:with(loveli.Label:new{ text = text, ismultiline = true, horizontaltextalignment = "start", verticaltextalignment = "start", width = "*", height = "*" } )
			)
		)
end
function love.load(arg)
	enabledebugger(arg)	
	layoutmanager = loveli.LayoutManager:new{}
		:with(loveli.StackLayout:new{ orientation = "horizontal", spacing = 10, width = "*", height = "auto", margin = loveli.Thickness.parse(10) }
			:with(card(150, 180, "Card 1", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In lorem metus, venenatis ac purus vehicula, aliquam congue metus.") )
			:with(card(150, 180, "Card 2", "Aenean et felis efficitur, fringilla dui a, bibendum lectus. Sed magna risus, posuere placerat tincidunt ut, blandit non mauris.") )
			:with(card(150, 180, "Card 3", "Fusce vel arcu nec sem placerat commodo nec at odio. Nullam eleifend ullamcorper varius.") )
		)
end
function love.keypressed(key, scancode, isrepeat)
	layoutmanager:keypressed(key, scancode, isrepeat)
end
function love.textinput(text)
	layoutmanager:textinput(text)
end
function love.mousepressed(x, y, button, istouch, presses)
	layoutmanager:mousepressed(x, y, button, istouch, presses)
end
function love.mousemoved(x, y, dx, dy, istouch)
  layoutmanager:mousemoved(x, y, dx, dy, istouch)
end
function love.joystickhat(joystick, hat, direction)
	layoutmanager:joystickhat(joystick, hat, direction)
end
function love.joystickpressed(joystick, button)
	layoutmanager:joystickpressed(joystick, button)
end
function love.resize(w, h)
	layoutmanager:resize(w, h)
end
function love.update(dt)
	layoutmanager:update(dt)
end
function love.draw()	
	love.graphics.clear(0.18, 0.18, 0.18)
	layoutmanager:draw()
end
function enabledebugger(arg)
	if arg[#arg] == "-debug" then 
		local debugger = require("mobdebug")
		debugger.start() 
	end	
	io.stdout:setvbuf("no")
end