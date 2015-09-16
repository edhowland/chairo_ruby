# pipe_factory.rb - class PipeFactory - constructs RenderPipeline

class PipeFactory
  def initialize
    @pipeline = RenderPipeline.new
    @gen = MdGen.new
    @pager = PageCounter.new

    @pipeline << ->(x) { @gen.process &x }
    @pipeline << ->(x) { @pager.process x }
  end

  # pass stuff through to pipeline.run
  def run initial=nil, &blk
    @pipeline.run initial, &blk
  end
end
