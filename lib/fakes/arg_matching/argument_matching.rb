module Fakes
  module ArgumentMatching

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

    module_function :not_nil
    module_function :nil
    module_function :any
    module_function :greater_than
    module_function :in_range
    module_function :regex
    module_function :condition
  end
end
