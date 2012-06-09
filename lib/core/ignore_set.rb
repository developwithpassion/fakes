module Fakes
  class IgnoreSet
    include ArgBehaviour

    def initialize
      array :arg_sets do|a|
        a.mutator :capture_args do|args|
          @times_called += 1
          @arg_sets << args
        end
      end
      @times_called = 0
    end

    def matches?(args)
      return true
    end

    def was_called_with?(args)
      matcher = ArgMatchFactory.create_arg_matcher_using(args)
      return @arg_sets.select{|set| matcher.matches?(set)}.count > 0
    end
  end
end
