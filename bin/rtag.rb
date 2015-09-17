#!/usr/bin/env ruby
# rtag.rb - ctags like print methods, classes, source file, line number

global_constants =[:Object, :Module, :Class, :BasicObject, :Kernel, :NilClass, :NIL, :Data, :TrueClass, :TRUE, :FalseClass, :FALSE, :Encoding, :Comparable, :Enumerable, :String, :Symbol, :Exception, :SystemExit, :SignalException, :Interrupt, :StandardError, :TypeError, :ArgumentError, :IndexError, :KeyError, :RangeError, :ScriptError, :SyntaxError, :LoadError, :NotImplementedError, :NameError, :NoMethodError, :RuntimeError, :SecurityError, :NoMemoryError, :EncodingError, :SystemCallError, :Errno, :UncaughtThrowError, :ZeroDivisionError, :FloatDomainError, :Numeric, :Integer, :Fixnum, :Float, :Bignum, :Array, :Hash, :ENV, :Struct, :RegexpError, :Regexp, :MatchData, :Marshal, :Range, :IOError, :EOFError, :IO, :STDIN, :STDOUT, :STDERR, :ARGF, :FileTest, :File, :Dir, :Time, :Random, :Signal, :Proc, :LocalJumpError, :SystemStackError, :Method, :UnboundMethod, :Binding, :Math, :GC, :ObjectSpace, :Enumerator, :StopIteration, :RubyVM, :Thread, :TOPLEVEL_BINDING, :ThreadGroup, :Mutex, :ThreadError, :Process, :Fiber, :FiberError, :Rational, :Complex, :RUBY_VERSION, :RUBY_RELEASE_DATE, :RUBY_PLATFORM, :RUBY_PATCHLEVEL, :RUBY_REVISION, :RUBY_DESCRIPTION, :RUBY_COPYRIGHT, :RUBY_ENGINE, :TracePoint, :ARGV, :Gem, :RbConfig, :CROSS_COMPILING, :ConditionVariable, :Queue, :SizedQueue, :MonitorMixin, :Monitor, :RUBYGEMS_ACTIVATION_MONITOR]

rfile = ARGV.first
require rfile
local_constants =  self.class.constants - global_constants

local_constants.each do |c|
  con = self.class.const_get c
  if con.class == Module
    o = Object.new
    o.extend con

  this_methods = con.instance_methods
    method_o = this_methods.map {|m| o.method m }
    method_o.map {|m| "#{m.name}|#{con.name}|#{m.source_location}" }.each {|s| puts s }
  elsif con.class == Class
  this_methods = con.instance_methods(false)
  ancestor = con.ancestors[1] # strange con is its own ancestor
    this_methods.each {|m| puts "#{m}|#{con}|#{rfile}"}
  else
    # intentially empty
  end
end
