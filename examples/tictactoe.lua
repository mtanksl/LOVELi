local license = [[
MIT License

Copyright (c) 2026 https://github.com/mtanksl

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]
local loveli = require("LOVELi")
local state = {
		token = -1,
		board = {}, -- 0 = empty, -1 = X token, 1 = O token
		gameover = false,
		screen = 0, -- 0 = home, 1 = game, 2 = options, 3 = credits
		refresh = false
}
function love.load(arg)
	enabledebugger(arg)
	layoutmanager = loveli.LayoutManager:new{}
    :with(loveli.AbsoluteLayout:new{ width = "*", height = "*", margin = loveli.Thickness.parse(10) }
			-- Home
			:with(loveli.StackLayout:new{ orientation = "vertical", spacing = 10, width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "center", name = "home" }
				:with(loveli.Label:new{ text = "Tic-Tac-Toe", font = love.graphics.newFont(20), width = "auto", height = "auto", margin = loveli.Thickness.parse(10) } )
				:with(loveli.Button:new{ clicked = function(sender) 
					state.screen = 1 
					state.refresh = true 
				end, text = "Continue", width = 75, height = 23, horizontaloptions = "center", name = "continue", isvisible = false } )
				:with(loveli.Button:new{ clicked = function(sender)
					state.board = { {0, 0, 0}, {0, 0, 0}, {0, 0, 0} }
					state.gameover = false 
					state.screen = 1 
					state.refresh = true
					if state.token == -1 then
						layoutmanager:getcontrol("status"):settext("Player X turn")
					else
						layoutmanager:getcontrol("status"):settext("Player O turn")
					end
				end, text = "New Game", width = 75, height = 23, horizontaloptions = "center" } )
				:with(loveli.Button:new{ clicked = function(sender) 
					state.screen = 2
					state.refresh = true
				end, text = "Options", width = 75, height = 23, horizontaloptions = "center" } )
				:with(loveli.Button:new{ clicked = function(sender) 
					state.screen = 3 
					state.refresh = true 
				end, text = "Credits", width = 75, height = 23, horizontaloptions = "center" } )
				:with(loveli.Button:new{ clicked = function(sender) 
					love.event.quit() 
				end, text = "Exit", width = 75, height = 23, horizontaloptions = "center" } )
			)
			-- Game
			:with(loveli.Grid:new{ rowdefinitions = { "1*", 460, "1*" }, columndefinitions = { "1*", 460, "1*" }, width = "*", height = "*", name = "game", isvisible = false }
				:with(2, 2, loveli.StackLayout:new{ orientation = "vertical", spacing = 10, width = "*", height = "*", horizontaloptions = "center", verticaloptions = "center" }
					:with(loveli.GraphicsView:new{
						clicked = function(sender, x, y)
							if state.gameover then
								state.board = { {0, 0, 0}, {0, 0, 0}, {0, 0, 0} }
								state.gameover = false 
								state.screen = 1 
								state.refresh = true
								if state.token == -1 then
									layoutmanager:getcontrol("status"):settext("Player X turn")
								else
									layoutmanager:getcontrol("status"):settext("Player O turn")
								end
							else
								local relativex = x - sender:getscreenx() - sender:getmargin():getleft()
								local relativey = y - sender:getscreeny() - sender:getmargin():gettop()
								local width = sender:getscreenwidth() - sender:getmargin():gethorizontal()
								local height = sender:getscreenheight() - sender:getmargin():getvertical()
								if relativex >= 0 and relativey >= 0 and relativex < width and relativey < height then
									local cellwidth = width / 3
									local cellheight = height / 3
									local i = math.floor(relativex / cellwidth) + 1
									local j = math.floor(relativey / cellheight) + 1
									if state.board[j][i] == 0 then
										state.board[j][i] = state.token
										state.token = -state.token
										state.refresh = true
										local lines = winner()
										if #lines > 0 then
											if lines[1].token == -1 then
												layoutmanager:getcontrol("status"):settext("Player X won (click to start a new game)")
											else
												layoutmanager:getcontrol("status"):settext("Player O won (click to start a new game)")
											end
											state.gameover = true
										elseif isdraw() then
											layoutmanager:getcontrol("status"):settext("Draw (click to start a new game)")
											state.gameover = true
										else
											if state.token == -1 then
												layoutmanager:getcontrol("status"):settext("Player X turn")
											else
												layoutmanager:getcontrol("status"):settext("Player O turn")
											end
										end
									end
								end
							end
						end,
						drawable = function(sender, x, y)
							local width = sender:getscreenwidth() - sender:getmargin():gethorizontal()
							local height = sender:getscreenheight() - sender:getmargin():getvertical()
							local cellwidth = width / 3
							local cellheight = height / 3
							local margin = 10
							-- Draw board
							love.graphics.setLineWidth(5)
							love.graphics.setColor(0, 0, 0, 1)
							for i = 1, 2 do
								-- Vertical line
								love.graphics.line(
									x + i * cellwidth,
									y, 
									x + i * cellwidth,
									y + height)
								-- Horizontal line
								love.graphics.line(
									x, 
									y + i * cellheight,
									x + width, 
									y + i * cellheight)
							end
							-- Draw tokens
							for j = 1, 3 do
								for i = 1, 3 do
									if state.board[j][i] == -1 then
										-- X token
										love.graphics.setColor(0, 0, 1, 1)
										love.graphics.line(
											x + (i - 1) * cellwidth + margin, 
											y + (j - 1) * cellheight + margin, 
											x + (i - 1) * cellwidth + cellwidth - margin, 
											y + (j - 1) * cellheight + cellheight - margin)
										love.graphics.line(
											x + (i - 1) * cellwidth + cellwidth - margin, 
											y + (j - 1) * cellheight + margin, 
											x + (i - 1) * cellwidth + margin, 
											y + (j - 1) * cellheight + cellheight - margin)
									elseif state.board[j][i] == 1 then
										-- O token
										love.graphics.setColor(1, 0, 0, 1)
										love.graphics.ellipse(
											"line",
											x + (i - 1) * cellwidth + cellwidth / 2, 
											y + (j - 1) * cellheight + cellheight / 2,
											cellwidth / 2 - 2 * margin, 
											cellheight / 2 - 2 * margin)
									end
								end
							end
							-- Draw cross-out
							love.graphics.setColor(0, 0, 0, 1)
							for _, line in ipairs(winner()) do
								if line.direction == "row" then
									love.graphics.line(
										x, 
										y + (line.index - 1) * cellheight + cellheight / 2,
										x + width, 
										y + (line.index - 1) * cellheight + cellheight / 2)
								elseif line.direction == "column" then
									love.graphics.line(
										x + (line.index - 1) * cellwidth + cellwidth / 2,
										y, 
										x + (line.index - 1) * cellwidth + cellwidth / 2,
										y + height)
								elseif line.direction == "diagonal" then
									love.graphics.line(
										x, 
										y, 
										x + width, 
										y + height)
								elseif line.direction == "diagonal2" then
									love.graphics.line(
										x + width, 
										y, 
										x, 
										y + height)
								end
							end						
							love.graphics.setLineWidth(1) -- Reset line width settings
						end, 
						width = "*", height = "*", margin = loveli.Thickness.parse(25)
					} )
					:with(loveli.Label:new{ text = "Player X turn", width = "*", height = "auto", horizontaloptions = "center", name = "status" } )
				)
			)
			-- Options
			:with(loveli.StackLayout:new{ orientation = "vertical", spacing = 10, width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "center", name = "options", isvisible = false }
				:with(loveli.Label:new{ text = "Music:" } )
				:with(loveli.Slider:new{ valuechanged = function(sender, oldvalue, newvalue) 
						--TODO: Set music volume with newvalue
					end, value = 8, minimum = 0, maximum = 10 } )					
				:with(loveli.Label:new{ text = "Sound Effect:" } )
				:with(loveli.Slider:new{ valuechanged = function(sender, oldvalue, newvalue) 
						--TODO: Set sound effect volume with newvalue
					end, value = 5, minimum = 0, maximum = 10 } )					
				:with(loveli.Button:new{ clicked = function(sender) 
						state.screen = 0 
						state.refresh = true 
					end, text = "Back", width = 75, height = 23, horizontaloptions = "center" } )
			)	
			-- Credits
			:with(loveli.StackLayout:new{ orientation = "vertical", spacing = 10, width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "center", name = "credits", isvisible = false }
				:with(loveli.Label:new{ text = license, ismultiline = true, width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "center" } )
				:with(loveli.Button:new{ clicked = function(sender) 
					state.screen = 0 
					state.refresh = true
				end, text = "Back", width = 75, height = 23, horizontaloptions = "center" } )
			)
		)
end
function winner()
	local lines = {}
  for i = 1, 3 do
    if state.board[i][1] ~= 0 and state.board[i][1] == state.board[i][2] and state.board[i][2] == state.board[i][3] then
      table.insert(lines, { token = state.board[i][1], direction = "row", index = i } )
    end
    if state.board[1][i] ~= 0 and state.board[1][i] == state.board[2][i] and state.board[2][i] == state.board[3][i] then
      table.insert(lines, { token = state.board[1][i], direction = "column", index = i } )
    end
  end
  if state.board[1][1] ~= 0 and state.board[1][1] == state.board[2][2] and state.board[2][2] == state.board[3][3] then
    table.insert(lines, { token = state.board[1][1], direction = "diagonal" } )
  end
  if state.board[1][3] ~= 0 and state.board[1][3] == state.board[2][2] and state.board[2][2] == state.board[3][1] then
    table.insert(lines, { token = state.board[1][3], direction = "diagonal2" } )
  end
  return lines
end
function isdraw()
  for j = 1, 3 do
    for i = 1, 3 do
      if state.board[j][i] == 0 then 
				return false 
			end
    end
  end
  return true
end
function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		if state.screen == 0 and #state.board > 0 then
			state.screen = 1
			state.refresh = true
		elseif state.screen == 1 and #state.board > 0 then
			state.screen = 0
			state.refresh = true
		elseif state.screen == 2 or state.screen == 3 then
			state.screen = 0
			state.refresh = true
		end
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
local previousscreen = nil
function love.update(dt)
	if state.refresh == true then
		state.refresh = false
		if previousscreen ~= state.screen then
			previousscreen = state.screen
			layoutmanager:getcontrol("home"):setisvisible(false)
			layoutmanager:getcontrol("game"):setisvisible(false)
			layoutmanager:getcontrol("options"):setisvisible(false)
			layoutmanager:getcontrol("credits"):setisvisible(false)
			if state.screen == 0 then
				layoutmanager:getcontrol("home"):setisvisible(true)
			elseif state.screen == 1 then
				layoutmanager:getcontrol("game"):setisvisible(true)
				layoutmanager:getcontrol("continue"):setisvisible(true)
			elseif state.screen == 2 then
				layoutmanager:getcontrol("options"):setisvisible(true)
			elseif state.screen == 3 then
				layoutmanager:getcontrol("credits"):setisvisible(true)
			end
			layoutmanager:invalidate()
		else
			layoutmanager:getcontrol("game"):invalidate()
		end
	end	
	layoutmanager:update(dt)
end
function love.draw()	
	love.graphics.clear(0.92, 0.92, 0.92)
	layoutmanager:draw()
end
function enabledebugger(arg)
	if arg[#arg] == "-debug" then 
		local debugger = require("mobdebug")
		debugger.start() 
	end	
	io.stdout:setvbuf("no")
end