# gfm_render.rb - class GfmRender

class GfmRender
  def initialize
  end

  def heading count, string
    "#{'#' * count} #{string}\n"
  end

  def h1 string
    heading 1, string
  end

  def h2 string
    heading 2, string
  end

  def h3 string
    heading 3, string
  end

def h4 string
    heading 4, string
  end

  def h5 string
    heading 5, string
  end

  def h6 string
    heading 6, string
  end

  def para string  #arr
    string + "\n"
  end

  def code string
    "\`\`\`\n#{string}\n\`\`\`\n"
  end

  def ul list
    list.reduce('') {|i, j| i << "- #{j}\n" }
  end

def ol list
    list.each_with_index.map {|e, i| "#{i+1}. #{e}" }.reduce('') {|i, j| i << "#{j}\n" }
  end

  def a urlspec
    "[#{urlspec[0]}](#{urlspec[1]})"
  end

  def insert_dashes arr
    col_count = arr[0].length
    [arr[0], (['----'] * col_count) ] + arr[1..(-1)]
  end
  def table arr
    insert_dashes(arr).map {|e| e.join('|') }.join("\n") + "\n"
  end

  def html_table arr, attrs={}
    r = Builder::XmlMarkup.new 
    r.table(attrs) { arr.each {|row| r << "\n"; r.tr { row.each {|col| r.td col  } } } } + "\n"
  end

  def html_a attr_h
    r = Builder::XmlMarkup.new 
    r.a(attr_h)
  end


  # filter :page from list, then run map/reduce on the rest
  def render codes
    codes.select {|e| e[0] != :page  }.map {|e| self.send e[0], e[1] }.reduce('') {|i, j| i << "#{j}\n" }
  end
end
