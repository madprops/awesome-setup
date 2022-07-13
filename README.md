![](https://i.imgur.com/IVpRXUC.jpg)

Here is my awesomewm setup.

It's built around floating windows.

Tiling features are intentionally stripped away.

Tiling is done manually through rules.

There's also no titlebars at all.

Instead there's right clicking the taskbar.

I make heavy use of the widgets and libraries that I wrote in "madwidgets".

You should be able to use madwidgets in other setups too, if you copy the whole thing.

To use, clone this in ~/.config

Rename the dir to "awesome".

Restart awesome.

# Modules

## autostart.lua
Programs to start/call when awesome starts

## bindings.lua
Keyboard and mouse bindings

## menupanels.lua
My menupanel (madwidget) setup

## notifications.lua
Naughty notifications setup

## rules.lua
Window rules, how and where programs get displayed

## screens.lua
Where the screen and panel get built

## theme.lua
Some custom theming rules

## utils.lua
Utilities and functions

## clients.lua
Client signals

# Other programs used

>numlockx

>xset

>setxkbmap

>systemctl

>pavucontrol

>spectacle

>playerctl

>rofi

>i3lock

>firefox

>some scripts of mine

>geany

>osmo

>alacritty

>clipton

>tilix

>killall

>echo

>cat

>sponge

>onboard

>htop

>nethogs

# Some shortcuts

Win + Backspace

>Toggle maximize

---

Win + Shift + Backspace

>Toggle fullscreen

---

Win + Numpad number

>Snap to the region represented by the numpad

---

Win + \

>Move to other monitor

---

Win + Mouse wheel

>Resize at center

---

ScrLk

>Toggle dropdown terminal

---

Middle click on bottom left icon

>Lock screen

---

Win + Spacebar

>Open Rofi

---

Win + `

>Open the main menupanel

---

Ctrl + `

>Open the clipboard manager

---

Right click on tag

>Move window to that tag

---

Alt + Tab

>Show Rofi in altab mode

---

Right click tasklist item

>Show a menupanel with actions on that client

---

Click green sysmonitors

>Open htop

---

Click on blue sysmonitors

>Open nethogs

---

Click on volume control

>Open pavucontrol

---

Click on date

>Open the osmo calendar

---

Alt + F4

>Close client

---

Double tap the mouse DPI button

>Close client

To do this, bind Win + Delete to the DPI button

That's what I do at least, and it's very efficient