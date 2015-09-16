#!/usr/bin/env ruby
# requires.rb - gaters all .rb files in dir tree, get their their requires

requires_h = {}

src = ARGV.first

Dir["#{src}/**/*.rb"].each do |rb|
  puts "#{rb}"
end
