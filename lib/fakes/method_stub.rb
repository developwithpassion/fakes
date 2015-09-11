module Fakes
  class MethodStub
    def initialize(arg_sets = [])
      @arg_sets = arg_sets
    end

    def add_new_argument_set(set)
      @arg_sets << set
      set
    end

    def with(*args)
      add_new_argument_set(ArgSet.new(args))
    end

    def throws(exception)
      ignore_arg.throws(exception)
    end

    def run(&block)
      ignore_arg.run(&block)
    end

    def ignore_arg
      add_new_argument_set(IgnoreSet.new)
    end

    def and_return(item)
      ignore_arg.and_return(item)
    end

    def invoke(args)
      set = @arg_sets.find { |item| item.matches?(args) } || ignore_arg
      set.capture_args(args)
      set.process
    end

    def called_with(*args)
      @arg_sets.find { |item| item.was_called_with?(args) }
    end

    def total_times_called
      @arg_sets.inject(0) { |sum, item| sum + item.times_called }
    end

    def times?(value)
      total_times_called == value
    end
  end
end
