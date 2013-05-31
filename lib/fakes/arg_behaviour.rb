module Fakes
  module ArgBehaviour
    attr_accessor :return_value,:times_called,:arg_matcher

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
      @times_called += 1
      @called_args = args
    end

    def matches?(args)
      return @arg_matcher.matches?(args)
    end

    def was_called_with?(args)
      ArgMatchFactory.create_arg_matcher_using(args).matches?(@called_args)
    end

    def process
      return @return_value unless @exception
      if @exception
        raise @exception
      end
    end
  end
end
