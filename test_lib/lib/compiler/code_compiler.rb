# code_compiler.rb - class CodeCompiler

class CodeCompiler
  def initialize
    @codes = []
  end

  attr_reader :codes

  def clear
    @codes = []
  end
end
