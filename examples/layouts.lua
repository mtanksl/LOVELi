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
	local font = loveli.Property.parse(love.graphics.getFont() )
	local textcolor = loveli.Property.parse(loveli.Color.parse(0xFFFFFFFF) )
	local textcolormuted = loveli.Property.parse(loveli.Color.parse(0x7F7F7FFF) )
	label = loveli.Label:new{ text = "FPS: 0", font = font, textcolor = textcolor, x = 0, y = 0, width = 75, height = "auto" } 
	layoutmanager = loveli.LayoutManager:new{}
		:with(loveli.AbsoluteLayout:new{ width = "*", height = "*", margin = loveli.Thickness.parse(10) }
			:with(label)
			:with(loveli.Label:new{ text = "Press ESC to show layout lines", font = font, textcolor = loveli.Color.parse(0x00FF00FF), x = 0, y = 0, width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "end" } )
			:with(loveli.Grid:new{ rowdefinitions = { "1*" }, columndefinitions = { "1*", "1*", "1*" }, x = 0, y = 0, width = "*", height = "*" }
				:with(1, 1, loveli.StackLayout:new{ orientation = "vertical", spacing = 10, width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "center" }
					:with(loveli.Label:new{ text = "AbsoluteLayout:", font = font, textcolor = textcolor } )
					:with(loveli.AbsoluteLayout:new{ width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "center", margin = loveli.Thickness.parse(10) }
						:with(loveli.Button:new{ x = 0, y = 0, text = "Button 1", width = 75, height = 23 } )
						:with(loveli.Button:new{ x = 60, y = 30, text = "Button 2", width = 75, height = 23 } )
						:with(loveli.Button:new{ x = 30, y = 60, text = "Button 3", width = 75, height = 23 } )
					)
					:with(loveli.Label:new{ text = "StackLayout (vertical):", font = font, textcolor = textcolor } )
					:with(loveli.StackLayout:new{ orientation = "vertical", width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "center", margin = loveli.Thickness.parse(10) }
						:with(loveli.Button:new{ text = "Button 1", width = 75, height = 23 } )
						:with(loveli.Button:new{ text = "Button 2", width = 75, height = 23 } )
						:with(loveli.Button:new{ text = "Button 3", width = 75, height = 23 } )
					)
					:with(loveli.Label:new{ text = "StackLayout (horizontal):", font = font, textcolor = textcolor } )
					:with(loveli.StackLayout:new{ orientation = "horizontal", width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "center", margin = loveli.Thickness.parse(10) }
						:with(loveli.Button:new{ text = "B1", width = 23, height = 75 } )
						:with(loveli.Button:new{ text = "B2", width = 23, height = 75 } )
						:with(loveli.Button:new{ text = "B3", width = 23, height = 75 } )
					)
				)
				:with(1, 2, loveli.StackLayout:new{ orientation = "vertical", spacing = 10, width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "center" }
					:with(loveli.Label:new{ text = "FlexLayout (row):", font = font, textcolor = textcolor } )
					:with(loveli.FlexLayout:new{ direction = "row", justifycontent = "center", aligncontent = "spaceevenly", width = 100, height = 60, horizontaloptions = "center", verticaloptions = "center", margin = loveli.Thickness.parse(10) }
						:with(loveli.Button:new{ text = "B1", width = 23, height = 23 } )
						:with(loveli.Button:new{ text = "B2", width = 23, height = 23 } )
						:with(loveli.Button:new{ text = "B3", width = 23, height = 23 } )
						:with(loveli.Button:new{ text = "B4", width = 23, height = 23 } )
						:with(loveli.Button:new{ text = "B5", width = 23, height = 23 } )
						:with(loveli.Button:new{ text = "B6", width = 23, height = 23 } )
						:with(loveli.Button:new{ text = "B7", width = 23, height = 23 } )
					)
					:with(loveli.Label:new{ text = "(justify center and\nalign spaceevenly)", ismultiline = true, font = font, textcolor = textcolormuted, horizontaloptions = "center" } )
					:with(loveli.Label:new{ text = "FlexLayout (column):", ismultiline = true, font = font, textcolor = textcolor } )
					:with(loveli.FlexLayout:new{ direction = "column", height = 100, horizontaloptions = "center", verticaloptions = "center", margin = loveli.Thickness.parse(10) }
						:with(loveli.Button:new{ text = "B1", width = 23, height = 23 } )
						:with(loveli.Button:new{ text = "B2", width = 23, height = 23 } )
						:with(loveli.Button:new{ text = "B3", width = 23, height = 23 } )
						:with(loveli.Button:new{ text = "B4", width = 23, height = 23 } )
						:with(loveli.Button:new{ text = "B5", width = 23, height = 23 } )
						:with(loveli.Button:new{ text = "B6", width = 23, height = 23 } )
						:with(loveli.Button:new{ text = "B7", width = 23, height = 23 } )
					)					
				)
				:with(1, 3, loveli.StackLayout:new{ orientation = "vertical", spacing = 10, width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "center" }
					:with(loveli.Label:new{ text = "Border:", font = font, textcolor = textcolor } )
					:with(loveli.Border:new{ bordercolor = textcolor, backgroundcolor = loveli.Color.parse(0x0000FFFF), padding = loveli.Thickness.parse(10), margin = loveli.Thickness.parse(10) }
						:with(loveli.Button:new{ text = "Button 1", width = 100, height = 23 } )
					)
					:with(loveli.Label:new{ text = "ScrollView (both):", font = font, textcolor = textcolor } )
					:with(loveli.ScrollView:new{ orientation = "both", verticalscrollbarincrement = 10, horizontalscrollbarincrement = 10, width = 60, height = 100, horizontaloptions = "center", verticaloptions = "center", margin = loveli.Thickness.parse(10) }
						:with(loveli.StackLayout:new{ orientation = "vertical", spacing = 5, width = "auto", height = "auto" }
							:with(loveli.Button:new{ text = "Button 1", width = 75, height = 23 } )
							:with(loveli.Button:new{ text = "Button 2", width = 75, height = 23 } )
							:with(loveli.Button:new{ text = "Button 3", width = 75, height = 23 } )
							:with(loveli.Button:new{ text = "Button 4", width = 75, height = 23 } )
							:with(loveli.Button:new{ text = "Button 5", width = 75, height = 23 } )
						)
					)
					:with(loveli.Label:new{ text = "(use shift + scroll\nfor horizontal scrolling)", ismultiline = true, font = font, textcolor = textcolormuted, horizontaloptions = "center" } )
				)
			)
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