module DevelopWithPassion
  module Fakes
    class ArgSet
      include ArgBehaviour

      def initialize(*args)
        @args = *args
        @times_called = 0
      end
    end
  end
end
