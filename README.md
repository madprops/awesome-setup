![](https://i.imgur.com/tgjR5m1.jpg)

Here is my awesomewm setup.

It's built around floating windows.

Tiling features are intentionally stripped away.

Tiling is done manually through rules.

There's also no titlebars at all.

Instead there's right clicking the taskbar.

I make heavy use of the widgets and libraries that I wrote in "madwidgets".

You should be able to use madwidgets in other setups too, if you copy the whole thing.

I make heavy use of Rofi in my workflow.
Since it's easy to show list results of text or get input for commands. It's easy to create .desktop files in ~/.local/share/applications to make scripts visible.

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

>firefox-developer-edition

>some scripts

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

>btop

>nethogs

>ip

>sed

## Used by widgets

>awk

>sensors

>free

>cat

>mpstat

>sleep

>sed

>grep

>pamixer

>pkill

>espeak

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

>Move client to that tag

---

Alt + Tab

>Show Rofi in altab mode

---

Right click tasklist item

>Show a menupanel with actions on that client

---

Click on sysmonitors

>Open btop

>Open sensors

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

>Close client under cursor

To do this, bind Win + Delete to the DPI button

That's what I do at least, and it's very efficient

---

PrtSc

>Open Spectacle to take a region screenshot

Using Escape to cancel this shows more screenshot options

# Log

There's a simple log system that saves information to ~/.awm_log

It automatically saves "critical" notifications to it.

Other information can be added manually with the `add_to_log` function.

# Notes

If your mouse has topside buttons, you can use them for virtual desktop changing.