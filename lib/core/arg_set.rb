module Fakes
  class ArgSet
    include ArgBehaviour

    def initialize(args)
      initialize_matcher_using(args)
      @times_called = 0
    end
  end
end
