#!/usr/bin/env ruby
# requires.rb - gaters all .rb files in dir tree, get their their requires

requires_h = {}

src = ARGV.first

class RequireGatherer
  def initialize rb_file, req_h
    @requires_h = req_h
    @rb_file = rb_file
  end

  def store_require lib
    unless @requires_h[lib].nil?
      @requires_h[lib] << @rb_file
    else
      @requires_h[lib] = [@rb_file]
    end
  end

  def require lib
    store_require lib
  end

  def require_relative lib
      store_require_lib
  end
end




Dir["#{src}/**/*.rb"].each do |rb|
  puts "#{rb}"
end
