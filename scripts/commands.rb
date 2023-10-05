#!/usr/bin/env ruby
require "open3"
require "clipboard"

def pick_cmd(prompt, data)
  cmd = "rofi -dmenu -p '#{prompt}' -me-select-entry '' -me-accept-entry 'MousePrimary' -i"
  stdin, stdout, stderr, wait_thr = Open3.popen3(cmd)
  stdin.puts(data)
  stdin.close
  return stdout.read.strip
end

client = ARGV[0]
path = File.join(__dir__, "data/commands.data")
lines = File.readlines(path).reject{ |x| x.strip.empty? }
commands = []

for line in lines
  split = line.split(";")
  client_2 = split[0].strip
  command = split[1].strip

  if client == client_2
    commands.push(command)
  end
end

if commands.empty?
  return
end

cmd = pick_cmd("Select Command", commands)

if cmd.empty?
  return
end

clip = Clipboard.paste
cmd = cmd.gsub("$clipboard", clip)

sleep(0.1)
system("xdotool key Ctrl+u")

sleep(0.1)
system("xdotool type '#{cmd}'")

sleep(0.1)
system("xdotool key Return")