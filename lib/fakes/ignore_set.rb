module Fakes
  class IgnoreSet
    include ArgBehaviour
    attr_accessor :arg_sets

    def initialize
      @arg_sets = []
      @times_called = 0
    end

    def capture_args(args)
      @times_called += 1
      @arg_sets << args
    end

    def matches?(args)
      return true
    end


    def was_called_with?(args)
      return @arg_sets.select{|set| set == args}.count > 0
    end
  end
end
