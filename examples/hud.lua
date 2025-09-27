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
function love.load(arg)
	enabledebugger(arg)	
	local font = loveli.Property.parse(love.graphics.newFont(18) )
	local whitecolor = loveli.Property.parse(loveli.Color.parse(0xFFFFFFFF) )
	local greencolor = loveli.Property.parse(loveli.Color.parse(0x00FF00FF) )
	local darkgreencolor = loveli.Property.parse(loveli.Color.parse(0x008000FF) )
	local mustardcolor = loveli.Property.parse(loveli.Color.parse(0xFFCE18FF) )
	label = loveli.Label:new{ text = "FPS: 0", textcolor = whitecolor, width = 75, height = "auto", } 
	layoutmanager = loveli.LayoutManager:new{}
		:with(loveli.AbsoluteLayout:new{ width = "*", height = "*", margin = loveli.Thickness.parse(10) }
			:with(loveli.StackLayout:new{ orientation = "vertical", spacing = 10, x = 0, y = 0, width = "auto", height = "auto", horizontaloptions = "start", verticaloptions = "start" }
				:with(label)
				:with(loveli.GraphicsView:new{ drawable = function(sender, x, y, width, height) 
					love.graphics.setColor(darkgreencolor:getvalue():getrgba() ) 
					love.graphics.circle("fill", width / 2, height / 2, width / 2, height / 2) 
				end, width = 80, height = 80 } )
			)
			:with(loveli.StackLayout:new{ orientation = "horizontal", spacing = 10, x = 0, y = 0, width = "auto", height = "auto", horizontaloptions = "start", verticaloptions = "end" }
				:with(loveli.Label:new{ text = "100", font = font, textcolor = mustardcolor, width = 75, height = "auto" } )
				:with(loveli.Label:new{ text = "0", font = font, textcolor = mustardcolor, width = 75, height = "auto" } )
			)
			:with(loveli.Label:new{ text = "1:45", font = font, textcolor = mustardcolor, x = 0, y = 0, width = 75, height = "auto", horizontaloptions = "center", verticaloptions = "end" } )
			:with(loveli.StackLayout:new{ orientation = "vertical", spacing = 10, x = 0, y = 0, width = "auto", height = "auto", horizontaloptions = "end", verticaloptions = "end" }
				:with(loveli.Label:new{ text = "$ 800", font = font, textcolor = mustardcolor, width = 75, height = "auto" } )
				:with(loveli.Label:new{ text = "12 / 100", font = font, textcolor = mustardcolor, width = 75, height = "auto" } )
			)
			:with(loveli.Label:new{ text = "Press ESC to show layout lines", textcolor = greencolor, x = 0, y = 0, width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "center" } )
		)
end
function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		layoutmanager:setshowlayoutlines(not layoutmanager:getshowlayoutlines() )
		layoutmanager:invalidate()
	end
	layoutmanager:keypressed(key, scancode, isrepeat)
end
function love.textinput(text)
	layoutmanager:textinput(text)
end
function love.mousepressed(x, y, button, istouch, presses)
	layoutmanager:mousepressed(x, y, button, istouch, presses)
end
function love.mousereleased(x, y, button, istouch, presses)
	layoutmanager:mousereleased(x, y, button, istouch, presses)
end
function love.mousemoved(x, y, dx, dy, istouch)
  layoutmanager:mousemoved(x, y, dx, dy, istouch)
end
function love.wheelmoved(dx, dy)
  layoutmanager:wheelmoved(dx, dy)
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
	label:settext("FPS: " .. love.timer.getFPS() )
	label:invalidate()
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