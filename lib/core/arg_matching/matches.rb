module Fakes
  class Matches
    class << self
      def not_nil
        condition(lambda{|item| item != nil})
      end

      def nil
        condition(lambda{|item| item == nil})
      end

      def any
        condition(lambda{|ignored| true})
      end

      def greater_than(value)
        condition(lambda{|number| number > value})
      end
      

      def in_range(range)
        condition(lambda{|item| range === item})
      end

      def regex(regex)
        condition(lambda{|string| regex =~ string})
      end

      def condition(conditional_block)
        return BlockArgMatcher.new(conditional_block)
      end
    end
  end
end
