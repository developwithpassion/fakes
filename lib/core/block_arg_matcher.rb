module Fakes
  class BlockArgMatcher
    include ArgMatchProtocol

    def initialize(specification_block)
      @specification_block = specification_block
    end

    def matches?(item)
      @specification_block.call(item)
    end
  
  end
end
