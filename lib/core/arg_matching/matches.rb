module Fakes
  class Matches
    class << self
      def not_nil
        condition{|item| item != nil}
      end

      def nil
        condition{|item| item == nil}
      end

      def any
        condition{|ignored| true}
      end

      def greater_than(value)
        condition{|number| number > value}
      end
      

      def in_range(range)
        condition{|item| range === item}
      end

      def regex(regex)
        condition{|string| regex =~ string}
      end

      def condition(&conditional_block)
        return BlockArgMatcher.new(conditional_block)
      end
    end
  end
end
