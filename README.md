# LOVELi (LÖVE Layout & GUI)

A [LÖVE 2D](https://love2d.org/) retained mode layout and GUI library.
Includes StackLayout, AbsoluteLayout and Grid layouts.
Includes Label, Button, Image, CheckBox, RadioButton, Switch, ProgressBar, Slider, TextBox, Border and GraphicsView controls.
This library was inspired by .NET's MAUI controls.
Tested on version 11.5.

![Menu](/menu.png)

![Control](/controls.png)

# Why?

I needed a simple way for creating game menus and overlays. Since I did not find any simple - yet complete - library, I've written my own.

# How to

1. Copy LOVELi folder to your project.
2. Import the library and hook the following methods:
```lua
local loveli = require("LOVELi")
function love.load(arg)
  -- See below --
  layoutmanager = loveli.LayoutManager:new{}
    :with(rootcontrol)
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
  layoutmanager:draw()
end
```

## Layouts

3. Use one of the following layouts:

### StackLayout

A StackLayout organizes elements in a one-dimensional stack, either horizontally or vertically.

```lua
local stacklayout = loveli.StackLayout:new{ orientation = "vertical", spacing = 5, width = "*", height = "*", margin = loveli.Thickness.parse(10) } 
  :with(loveli.Button:new{ text = "Button 1", horizontaltextalignment = "start", verticaltextalignment = "center", width = 75, height = 23, horizontaloptions = "start" } )
  :with(loveli.Button:new{ text = "Button 2", horizontaltextalignment = "center", verticaltextalignment = "center", width = 75, height = "*", horizontaloptions = "center" } )
  :with(loveli.Button:new{ text = "Button 3", horizontaltextalignment = "end", verticaltextalignment = "center", width = 75, height = 23, horizontaloptions = "end" } )		
local rootcontrol = stacklayout
```

### AbsoluteLayout

An AbsoluteLayout is used to position and size elements using explicit values.

```lua
local absolutelayout = loveli.AbsoluteLayout:new{ width = 250, height = 250, margin = loveli.Thickness.parse(10) } 
  :with(loveli.Button:new{ text = "Top Left", horizontaltextalignment = "center", verticaltextalignment = "center", x = 0, y = 0, width = 75, height = 23 } )
  :with(loveli.Button:new{ text = "Top Center", horizontaltextalignment = "center", verticaltextalignment = "center", x = 125 -38.5, y = 0, width = 75, height = 23 } )
  :with(loveli.Button:new{ text = "Top Right", horizontaltextalignment = "center", verticaltextalignment = "center", x = 250 -75, y = 0, width = 75, height = 23 } )	
  :with(loveli.Button:new{ text = "Center Left", horizontaltextalignment = "center", verticaltextalignment = "center", x = 0, y = 125 -11.5, width = 75, height = 23 } )
  :with(loveli.Button:new{ text = "Center", horizontaltextalignment = "center", verticaltextalignment = "center", x = 125 -38.5, y = 125 -11.5, width = 75, height = 23 } )
  :with(loveli.Button:new{ text = "Center Right", horizontaltextalignment = "center", verticaltextalignment = "center", x = 250 -75, y = 125 -11.5, width = 75, height = 23 } )	
  :with(loveli.Button:new{ text = "Bottom Left", horizontaltextalignment = "center", verticaltextalignment = "center", x = 0, y = 250 -23, width = 75, height = 23 } )
  :with(loveli.Button:new{ text = "Bottom Center", horizontaltextalignment = "center", verticaltextalignment = "center", x = 125 -38.5, y = 250 -23, width = 75, height = 23 } )
  :with(loveli.Button:new{ text = "Bottom Right", horizontaltextalignment = "center", verticaltextalignment = "center", x = 250 -75, y = 250 -23, width = 75, height = 23 } )
local rootcontrol = absolutelayout
```

### Grid

A Grid is used for displaying elements in rows and columns, which can have proportional or absolute sizes. 

```lua
local grid = loveli.Grid:new{ rowdefinitions = { "auto", "1*", "1*" }, columndefinitions = { "auto", "1*", 150 }, width = "*", height = "*", margin = loveli.Thickness.parse(10) } 
  :with(1, 1, absolutelayout)
  :with(2, 2, stacklayout)
local rootcontrol = grid
```

## Controls

4. And the following controls:

### Label

Label displays single, or multiple, lines of text. 

```lua
loveli.Label:new{ text = "Label" }
```

### Button

Button displays text and responds to a tap or click that directs an app to carry out a task.

```lua
loveli.Button:new{
  text = "Button",
  clicked = function(sender) end, 
  -- Default values for text controls:
    ismultiline = false,
    font = love.graphics.getFont(),
    horizontaltextalignment = "center",
    verticaltextalignment = "center",
    textcolor = loveli.Color.parse(0x000000FF),
  -- Default values for style:
    backgroundcolor = loveli.Color.parse(0xC0C0C0FF),
    bordercolor = loveli.Color.parse(0xFFFFFFFF),
  -- Default values for size and position:
    x = 0,
    y = 0,
    width = "auto",
    height = "auto",
    minwidth = -1,
    minheight = math.huge,
    maxwidth = -1,
    maxheight = math.huge,
    margin = loveli.Thickness.parse(0),
    horizontaloptions = "start",
    verticaloptions = "start",
  -- Default values for all controls:
    name = nil,
    isvisible = true,
    isenabled = true
}
```

### Image

Image displays an image that can be loaded from a local file.

```lua
loveli.Image:new{ source = "icon.png", aspect = "aspectfit", width = 64, height = 32 }
```

### CheckBox

CheckBox enables you to select a boolean value using a type of button that can either be checked or empty.

```lua
loveli.CheckBox:new{ ischecked = false, checkedchanging = function(sender, oldvalue, newvalue) return true end, checkedchanged = function(sender, oldvalue, newvalue) end }
```

### RadioButton

RadioButton is a type of button that allows the selection of one option from a set. 

```lua
loveli.RadioButton:new{ ischecked = false, groupname = "1", checkedchanging = function(sender, oldvalue, newvalue) return true end, checkedchanged = function(sender, oldvalue, newvalue) end }
```

### Switch

Switch enables you to select a boolean value using a type of button that can either be on or off.

```lua
loveli.Switch:new{ istoggled = false, toggling = function(sender, oldvalue, newvalue) return true end, toggled = function(sender, oldvalue, newvalue) end }
```

### ProgressBar

ProgressBar uses an animation to show that the app is progressing through a lengthy activity.

```lua
loveli.ProgressBar:new{ progress = 0.75 }
```

### Slider

Slider enables you to select a value from a range. 

```lua
loveli.Slider:new{ value = 5, minimum = 0, maximum = 10, valuechanging = function(sender, oldvalue, newvalue) return true end, valuechanged = function(sender, oldvalue, newvalue) end }
```

### TextBox 

TextBox enables you to enter and edit a single, or multiple, lines of text.

```lua
local textbox = loveli.TextBox:new{ text = "TextBox", ispassword = false, textchanging = function(sender, oldvalue, newvalue) return true end, textchanged = function(sender, oldtext, newtext) end }
```

### Border

Border is a container control that adds padding around another control. 

```lua
local border = loveli.Border:new{ padding = loveli.Thickness.parse(10) }
  :with(textbox)
```

### GraphicsView

GraphicsView is a graphics canvas on which 2D graphics can be drawn. 

```lua
local graphicsview = loveli.GraphicsView:new{ drawable = function(sender, x, y, width, height) end, width = "*", height = "**" }
```

# Keyboard Accessibility

This library supports `tab`, `shift + tab`, `down` arrow and `up` arrow for navigation, `space` and `return` for action.

# Joystick Accessibility

This library supports `down` hat and `up` hat for navigation, `any button` for action.

# Support Us

If you enjoy using open source projects and would like to support our work, consider making a donation! Your contributions help us maintain and improve the project. You can support us by sending directly to the following address:

Bitcoin (BTC) Address: bc1qc2p79gtjhnpff78su86u8vkynukt8pmfnr43lf

Monero (XMR) Address: 87KefRhqaf72bYBUF3EsUjY89iVRH72GsRsEYZmKou9ZPFhGaGzc1E4URbCV9oxtdTYNcGXkhi9XsRhd2ywtt1bq7PoBfd4

Thank you for your support! Every contribution, no matter the size, makes a difference.