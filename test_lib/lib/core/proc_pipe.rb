# proc_pipe.rb - method | on Proc


class Proc
  def |(prc)
    @chain = prc
  end  

  attr_reader :chain

  def call_chain value
    unless @chain.nil?
      @chain.call_chain(self.call(value)) 
    else
      self.call(value)
  end
  end
end
