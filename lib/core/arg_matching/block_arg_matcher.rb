module Fakes
  class BlockArgMatcher

    def initialize(specification_block)
      @specification_block = specification_block
    end

    def matches?(item)
      @specification_block.call(item)
    end
  
  end
end
