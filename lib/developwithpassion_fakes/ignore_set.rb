module DevelopWithPassion
  module Fakes
    class IgnoreSet
      include ArgBehaviour

      def initialize
        @times_called = 0
      end

      def matches?(*args)
        return true
      end
    end
  end
end
