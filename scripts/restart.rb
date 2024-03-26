#!/usr/bin/env ruby
# Restart/redo last command

# Delay to ensure things work
delay = 0.125

# Trigger click to focus correct location
# For instance a specific terminal split
`xdotool click 1`

# Stop process if any
sleep(delay)
`xdotool key Ctrl+c`

# I needed this for some reason
sleep(delay)
`xdotool key Ctrl+u`

# Seek last command
sleep(delay)
`xdotool key Up`

# Execute command
sleep(delay)
`xdotool key Return`