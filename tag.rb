#!/usr/bin/env ruby
require "git"
repo = Git.open(".")
commit_count = `git rev-list --count HEAD`.strip.to_i
existing_tags = repo.tags.map(&:name)
next_suffix = commit_count

while existing_tags.include?("v#{next_suffix}")
  next_suffix += 1
end

name = "v#{next_suffix}"
repo.add_tag(name)
repo.push("origin", name)
puts "Created tag: #{name}"