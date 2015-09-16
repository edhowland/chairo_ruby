# pdf_rend.rb - class PdfRend use with MdGen to render pdfs w/Prawn

class PdfRend
  def initialize pathname
@pathname = pathname
    @formatter = PdfTextFormat.new
  end

  def para doc,  arr
    # call out to Prawn text method
  doc.text(@formatter.format(arr))
  end

  # render bytecodes via codes to PrawnDocument
  # calls methods in this class whick will call Prawn::Document methods
  def render codes
    me = self
Prawn::Document.generate(@pathname) do |doc|
    codes.each {|code| me.send code[0], doc, code[1] }
  end
    
  end
end
