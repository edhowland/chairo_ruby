# pdf_text_format.rb - class PdfTextFormat

class PdfTextFormat
  def t string
    string
  end

  def ital string
      string
  end

  def bold string
  string
  end

  def format arr
    arr.map {|e| self.send e[0], e[1] }.reduce('') {|i, j| i << j }
  end
end
