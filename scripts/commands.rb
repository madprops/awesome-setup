#!/usr/bin/env ruby
require "open3"

def pick_cmd(prompt, data)
  cmd = "rofi -dmenu -p '#{prompt}' -me-select-entry '' -me-accept-entry 'MousePrimary' -i"
  stdin, stdout, stderr, wait_thr = Open3.popen3(cmd)
  stdin.puts(data.split("\n"))
  stdin.close
  return stdout.read.strip
end

path = File.join(__dir__, "data/commands.data")
data = File.read(path).strip
cmd = pick_cmd("Select Command", data)

if cmd.empty?
  return
end

sleep(0.1)
system("xdotool type '#{cmd}'")

sleep(0.1)
system("xdotool key Return")