module Fakes
  class MethodStub
    def initialize(arg_sets = [])
      array :arg_sets do|a|
        a.mutator :add_new_set do|set|
          @arg_sets << set
          set
        end
      end
      @arg_sets = arg_sets
    end

    def with(*args)
      return add_new_set(ArgSet.new(args))
    end

    def throws(exception)
      ignore_arg.throws(exception)
    end

    def ignore_arg
      return add_new_set(IgnoreSet.new)
    end

    def and_return(item)
      ignore_arg.and_return(item)
    end


    def invoke(args)
      set = @arg_sets.find{|item| item.matches?(args)} || ignore_arg
      set.capture_args(args)
      return set.process
    end

    def called_with(*args)
      return @arg_sets.find{|item| item.was_called_with?(args)}
    end

    def total_times_called
      return @arg_sets.inject(0){|sum,item|sum += item.times_called}
    end

    def times?(value)
      return total_times_called == value
    end
  end
end
