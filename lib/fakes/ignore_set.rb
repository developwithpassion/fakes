module Fakes
  class IgnoreSet
    include ArgBehaviour

    def initialize
      @times_called = 0
    end

    def arg_sets
      @arg_sets ||= []
    end

    def capture_args(args)
      super
      arg_sets << args
    end

    def matches?(_args)
      true
    end

    def was_called_with?(args)
      matcher = ArgMatchFactory.create_arg_matcher_using(args)
      arg_sets.count { |set| matcher.matches?(set) } > 0
    end
  end
end
