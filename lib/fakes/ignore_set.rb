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
      @times_called += 1
      self.arg_sets << args
    end

    def matches?(args)
      return true
    end

    def was_called_with?(args)
      matcher = ArgMatchFactory.create_arg_matcher_using(args)
      return arg_sets.select{|set| matcher.matches?(set)}.count > 0
    end
  end
end
