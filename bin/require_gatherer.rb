# require_gatherer.rb - class RequireGatherer

class NullObject
  def method_missing method, *args, &blk
  end
end


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
      store_require lib
  end

  def self.const_missing name
  puts "missing constant #{name}"
    NullObject.new
  end

  def method_missing(method, *args, &blk)
    puts "missing method #{method}"
  end

  def eval contents
    instance_eval contents
  end
end
