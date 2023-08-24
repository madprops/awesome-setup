#!/usr/bin/env ruby

# Add this to the fish config:

# function intercept --on-event fish_postexec
#   if [ "$status" != 0 ]
#     return
#   end

#   ruby ~/.config/awesome/scripts/save_command.rb $argv
# end

if ARGV[0].nil?
  return
end

cmd = ARGV[0].strip

if cmd.empty?
  return
end

xcmds_equals = ["cd", "ls", "lq", "z", "br", "o"]
xcmds_starts = ["cd", "z"]

if xcmds_equals.any? { |x| cmd == x }
  return
end

if xcmds_starts.any? { |x| cmd.start_with?(x) }
  return
end

path = File.join(__dir__, "data/commands.data")
max_items = 500
lines = []

File.open(path, "a+") do |file|
  lines = file.readlines
end

lines.prepend(cmd)
content = lines.map(&:chomp).uniq.take(max_items).join("\n")

File.open(path, "w") do |file|
  file.puts(content)
end