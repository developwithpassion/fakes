module Fakes
  module ArgBehaviour
    attr_accessor :return_value,:times_called,:arg_matcher
    attr_reader :callback_block

    def initialize_matcher_using(args)
      @arg_matcher = ArgMatchFactory.create_arg_matcher_using(args)
    end

    def and_return(item)
      @return_value = item
    end

    def throws(exception)
      @exception = exception
    end

    def capture_args(args)
      @arguments_provided = true
      @times_called += 1
      @called_args = args
    end

    def run(&callback_block)
      @callback_block = callback_block
    end

    def matches?(args)
      return @arg_matcher.matches?(args)
    end

    def was_called_with?(args)
      ArgMatchFactory.create_arg_matcher_using(args).matches?(@called_args)
    end

    def process
      if callback_block
        @arguments_provided ? callback_block.call(*@called_args) : callback_block.call
      else
        raise @exception if @exception
        @return_value 
      end
    end
  end
end
