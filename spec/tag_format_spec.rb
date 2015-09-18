# tag_format_spec.rb - specs for tag_format

require_relative 'spec_helper'

describe Rtags::VERSION do
  specify { Rtags::VERSION.wont_be_nil }
end

describe Rtags::Format do
  let(:format) { Rtags::Format.new 'file.rb:2' }
  describe 'method' do
  end

end
