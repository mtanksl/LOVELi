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
local backgroundcolor = loveli.Property.parse(loveli.Color.parse(0x25A4D9FF) )
function love.load(arg)
	enabledebugger(arg)	
	local font = loveli.Property.parse(love.graphics.getFont() )
	local textcolor = loveli.Property.parse(loveli.Color.parse(0xFFFFFFFF) )
	local offbackgroundcolor = loveli.Property.parse(loveli.Color.parse(0xC0C0C0FF) )
	label = loveli.Label:new{ text = "FPS: 0", font = font, textcolor = textcolor, x = 0, y = 0, width = 75, height = "auto" } 
	layoutmanager = loveli.LayoutManager:new{}
		:with(loveli.AbsoluteLayout:new{ width = "*", height = "*", margin = loveli.Thickness.parse(10) }
			:with(label)
			:with(loveli.Label:new{ text = "Press ESC to show layout lines", font = font, textcolor = loveli.Color.parse(0x00FF00FF), x = 0, y = 0, width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "end" } )
			:with(loveli.Grid:new{ rowdefinitions = { "1*" }, columndefinitions = { "1*", "1*", "1*" }, x = 0, y = 0, width = "*", height = "*" }
				:with(1, 1, loveli.StackLayout:new{ orientation = "vertical", spacing = 10, width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "center" }
					:with(loveli.Label:new{ text = "Label (multiline):", font = font, textcolor = textcolor } )
					:with(loveli.Label:new{ text = "The quick brown fox jumps over the lazy dog", ismultiline = true, font = font, textcolor = textcolor, width = 110, height = "auto", horizontaltextalignment = "center", verticaltextalignment = "center" } )
					:with(loveli.Label:new{ text = "Image (aspect fit):", font = font, textcolor = textcolor } )
					:with(loveli.Image:new{ source = "love2dicon2.png", aspect = "aspectfit", width = 64, height = 32 } )
					:with(loveli.Label:new{ text = "Image (aspect fill):", font = font, textcolor = textcolor } )
					:with(loveli.Image:new{ source = "love2dicon2.png", aspect = "aspectfill", width = 64, height = 32 } )
					:with(loveli.Label:new{ text = "Image (fill):", font = font, textcolor = textcolor } )
					:with(loveli.Image:new{ source = "love2dicon2.png", aspect = "fill", width = 64, height = 32 } )
					:with(loveli.Label:new{ text = "ProgressBar:", font = font, textcolor = textcolor } )
					:with(loveli.ProgressBar:new{ progress = 0.75, forecolor = textcolor, backgroundcolor = backgroundcolor, bordercolor = textcolor } )
					:with(loveli.Label:new{ text = "GraphicsView:", font = font, textcolor = textcolor } )
					:with(loveli.GraphicsView:new{ drawable = function(sender, x, y, width, height) love.graphics.setColor(backgroundcolor:getvalue():getrgba() ) love.graphics.rectangle("fill", x, y, width, height) end, width = 32, height = 32, margin = loveli.Thickness.parse(10) } )
				)
				:with(1, 2, loveli.StackLayout:new{ orientation = "vertical", spacing = 10, width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "center" }
					:with(loveli.Label:new{ text = "Button:", font = font, textcolor = textcolor } )
					:with(loveli.Button:new{ clicked = clicked, text = "Button", font = font, textcolor = textcolor, backgroundcolor = backgroundcolor, bordercolor = textcolor, width = 75, height = 23 } )
					:with(loveli.Label:new{ text = "CheckBox:", font = font, textcolor = textcolor } )
					:with(loveli.CheckBox:new{ checkedchanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, ischecked = false, forecolor = textcolor, backgroundcolor = backgroundcolor, bordercolor = textcolor } )
					:with(loveli.CheckBox:new{ checkedchanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, ischecked = true, forecolor = textcolor, backgroundcolor = backgroundcolor, bordercolor = textcolor } )
					:with(loveli.CheckBox:new{ checkedchanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, ischecked = nil, forecolor = textcolor, backgroundcolor = backgroundcolor, bordercolor = textcolor } )
					:with(loveli.Label:new{ text = "RadioButton:", font = font, textcolor = textcolor } )
					:with(loveli.RadioButton:new{ checkedchanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, ischecked = false, groupname = "1", forecolor = textcolor, backgroundcolor = backgroundcolor, bordercolor = textcolor } )
					:with(loveli.RadioButton:new{ checkedchanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, ischecked = true, groupname = "1", forecolor = textcolor, backgroundcolor = backgroundcolor, bordercolor = textcolor } )			
					:with(loveli.Label:new{ text = "Switch:", font = font, textcolor = textcolor } )
					:with(loveli.Switch:new{ toggled = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, istoggled = false, forecolor = textcolor, onbackgroundcolor = backgroundcolor, offbackgroundcolor = offbackgroundcolor, bordercolor = textcolor } )
					:with(loveli.Switch:new{ toggled = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, istoggled = true, forecolor = textcolor, onbackgroundcolor = backgroundcolor, offbackgroundcolor = offbackgroundcolor, bordercolor = textcolor } )
					:with(loveli.Label:new{ text = "Slider:", font = font, textcolor = textcolor } )
					:with(loveli.Slider:new{ valuechanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, value = 5, minimum = 0, maximum = 10, forecolor = textcolor, backgroundcolor = backgroundcolor, bordercolor = textcolor } )
				)
				:with(1, 3, loveli.StackLayout:new{ orientation = "vertical", spacing = 10, width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "center" }
					:with(loveli.Label:new{ text = "ImageButton (aspect fit):", font = font, textcolor = textcolor } )
					:with(loveli.ImageButton:new{ clicked = clicked, source = "love2dicon.png", aspect = "aspectfit", width = 64, height = 64 } )
					:with(loveli.Label:new{ text = "TextBox:", font = font, textcolor = textcolor } )
					:with(loveli.TextBox:new{ textchanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, text = "TextBox", font = font, textcolor = textcolor, backgroundcolor = backgroundcolor, bordercolor = textcolor, width = 100, height = 23 } )
					:with(loveli.Label:new{ text = "TextBox (multiline):", font = font, textcolor = textcolor } )
					:with(loveli.TextBox:new{ textchanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, text = "The quick brown fox jumps over the lazy dog", ismultiline = true, font = font, horizontaltextalignment = "center", verticaltextalignment = "center", textcolor = textcolor, backgroundcolor = backgroundcolor, bordercolor = textcolor, width = 100, height = "auto" } )
					:with(loveli.Label:new{ text = "MaskedTextBox:", font = font, textcolor = textcolor } )
					:with(loveli.MaskedTextBox:new{ textchanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, mask = "(000) 000-0000", patterns = { ["0"] = { pattern = "%d" } }, font = font, textcolor = textcolor, backgroundcolor = backgroundcolor, bordercolor = textcolor, width = "auto", height = "auto" } )
					:with(loveli.Label:new{ text = "Picker:", font = font, textcolor = textcolor } )
					:with(loveli.Picker:new{ selectedindexchanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, itemssource = { "Option 1", "Option 2", "Option 3", "Option 4", { tostring = function(self) return "Option 5" end } }, text = "Select...", font = font, textcolor = textcolor, backgroundcolor = backgroundcolor, bordercolor = textcolor, width = 100, height = "auto" } )
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
local bluetheme = true
function clicked(sender)
	print("Click!")
	if bluetheme then
		bluetheme = false
		backgroundcolor:setvalue(loveli.Color.parse(0xDF4794FF) )
	else
		bluetheme = true
		backgroundcolor:setvalue(loveli.Color.parse(0x25A4D9FF) )
	end
	layoutmanager:invalidate()
end
function enabledebugger(arg)
	if arg[#arg] == "-debug" then 
		local debugger = require("mobdebug")
		debugger.start() 
	end	
	io.stdout:setvbuf("no")
end