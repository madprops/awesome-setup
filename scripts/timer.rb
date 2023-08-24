#!/usr/bin/env ruby
require "open3"

def get_input(prompt, data)
  cmd = "rofi -dmenu -p '#{prompt}' -i"
  stdin, stdout, stderr, wait_thr = Open3.popen3(cmd)
  stdin.puts(data)
  stdin.close
  return stdout.read.strip
end

path = File.join(__dir__, "data/timer.data")
data = ""

File.open(path, "a+") do |file|
  data = file.read.strip
end

if ARGV.length >= 2
  title = ARGV[0]
  time = ARGV[1..-1].join(" ")
else

  title = get_input("Enter Title", data)

  if title == ""
    exit
  end

  times = "5m\n10m\n15m\n20m\n30m\n1h\n2h"
  time = get_input("Enter Time", times)

  if time == ""
    exit
  end
end

n = time.gsub(/[^0-9]/, "").strip.to_i
u = time.gsub(/[0-9]/, "").strip

if u == "m" or u.include?("min")
  t = n
elsif u == "s" or u.include?("sec")
  t = n / 60.0
elsif u == "h" or u.include?("hour")
  t = n * 60.0
else
  t = n
end

lines = data.split("\n")
lines.delete_if {|x| x == title}
lines.unshift(title)
File.write(path, lines.join("\n"))

`awesome-client 'Utils.timer("#{title}", #{t})'`