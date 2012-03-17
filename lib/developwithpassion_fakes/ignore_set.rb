module DevelopWithPassion
  module Fakes
    class IgnoreSet
      include ArgBehaviour
      attr_reader :arg_sets

      def initialize
        @times_called = 0
        @arg_sets = []
      end

      def matches?(*args)
        return true
      end

      def capture_args(*args)
        @times_called += 1
        @arg_sets << args
      end

      def was_called_with?(*args)
        return @arg_sets.select{|set| set == args}.count > 0
      end
    end
  end
end
