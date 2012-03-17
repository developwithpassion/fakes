module DevelopWithPassion
  module Fakes
    module ArgBehaviour
      attr_accessor :return_value,:times_called

      def and_return(item)
        @return_value = item
      end

      def capture_args(args)
        @times_called += 1
        @called_args = args
      end

      def matches?(args)
        puts @args.class
        puts args[0].class
        return @args == args
      end

      def was_called_with?(args)
        return @called_args == args
      end
    end
  end
end
