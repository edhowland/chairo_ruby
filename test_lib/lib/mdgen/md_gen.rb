# mdgen.rb - MdGen class DSL to generate Markdown

class MdGen < CodeCompiler
  class NestingTooDeep < RuntimeError
    def initialize
      super('Nesting Level Too Deep')
    end
  end

  def initialize
  super
  end


  def h l,  string, &blk
     raise MdGen::NestingTooDeep if l > 6

    headm = "h#{l}".to_sym
    @codes << [headm, string]
  yield l + 1 if block_given?
    @codes
  end
  def h1 string
    @codes << [:h1, string]
  end

  def h2 string
    @codes << [:h2, string]
  end

  def h3 string
    @codes << [:h3, string]
  end

  def h4 string
    @codes << [:h4, string]
  end

  def h5 string
    @codes << [:h5, string]
  end

  def h6 string
    @codes << [:h6, string]
  end

  def code string
    @codes << [:code, string]
  end

def para string
  #parser = TextParse.new
  
    # TODO: restructure to move text parse to its own lambda in pipeline
    #@codes << [:para, parser.parse(string)]

    @codes << [:para, string]
  end

  alias_method :text, :para

  def ordered_list(*list)
  list = list[0] if list[0].instance_of? Array
    @codes << [:ol, list]
  end

alias_method :numbers, :ordered_list

  def bullets *list
      @codes << [:ul, list]
  end

  def link title, url
    @codes << [:a, [title, url]]
  end

  def page(&blk)
  #yield if block_given?
    #@codes << [:page, 0, 0]
    @codes << [:page, blk]
  end

  def table arr
    @codes << [:table, arr]
  end

  def html_table arr, options={}
    @codes << [:html_table, arr, options]
  end

  # import a .mdsl file, process it and add opcodes to our @codes
  def import filename
  blk_str = File.read filename
    blk = eval blk_str
  self.instance_exec &blk
  end

  def html_a anchor_h
    @codes << [:html_a, anchor_h]
  end

  def eval_string string
    self.instance_eval string
    @codes
  end

  # process the block which contains the MDSL commads returning array of opcodes
def process(page_number=0, page_total=0, &blk)
    self.instance_exec(page_number, page_total, &blk)
    @codes
  end  

  # render the output as proper markdown
  # pass a renderer
  def render kit
    kit.render @codes
  end
end
