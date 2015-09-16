# text_format_valve.rb - method text_format_valve

def is_para? code
  code[0] == :para
end


def is_heading? code
  [:h1, :h2, :h3, :h4, :h5, :h6].include? code[0]
end

def is_para? code
  code[0] == :para
end

def is_list? code
  [:ul, :ol].include? code[0]
end

# process code stream, formatting operands where needed
def text_format_valve codes
  fmtr = TextFormat.new
  codes.map_select(->(x){ is_para?(x) || is_heading?(x)}) {|e| e[1] = fmtr.format(e[1]); e # para,  h1, h2, h3, h4, h5, h6
  }.map_select(->(x){ x[0] == :a})  {|e|name = e[1][0]; link = e[1][1]; name =  fmtr.format(name); [:a, [name, link]]  # link, :a
    }.map_select(->(x){is_list?(x)}) {|e| [e[0], e[1].map {|f| fmtr.format(f)}]} # bullets, numbers
end
