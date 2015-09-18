# format.rb - class Rtags::Format

module Rtags
  class Format
    def initialize
      @elements = []
    end
  
    # adds a method to format array
    def method method_o
      @elements << [method_o.name, method_o.source_location, nil, 'f']
    end

    def to_s
      @elements.map {|e| e.join("\t") }.join("\n")
    end
  end
end
