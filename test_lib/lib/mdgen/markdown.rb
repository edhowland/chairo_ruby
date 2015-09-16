# markdown.rb - markdown method to create correct markdown  output


# the main markdown object
def markdown(r=GfmRender.new,  &blk)
  g = MdGen.new
  g.process &blk

  r.render g.codes
end


