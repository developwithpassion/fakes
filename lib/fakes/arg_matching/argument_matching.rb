module Fakes
  module ArgumentMatching
    extend self

    def not_nil
      condition { |item| !item.nil? }
    end

    def nil
      condition(&:nil?)
    end

    def any
      condition { |ignored| true }
    end

    def greater_than(value)
      condition { |number| number > value }
    end

    def in_range(range)
      condition { |item| range.include?(item) }
    end

    def regex(pattern)
      condition { |string_argument| pattern =~ string_argument }
    end

    def condition(&conditional_block)
      BlockArgMatcher.new(conditional_block)
    end
  end
end
