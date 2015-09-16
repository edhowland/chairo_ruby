#!/usr/bin/env ruby
# requires.rb - gaters all .rb files in dir tree, get their their requires

requires_h = {}

src = ARGV.first
require_relative 'require_gatherer'

Dir["#{src}/**/*.rb"].each do |rb|
  puts "#{rb}"
  gather = RequireGatherer.new rb, requires_h
  gather.eval(File.read(rb))
end

puts "Final"
p requires_h
