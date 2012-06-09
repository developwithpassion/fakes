module Fakes
  class CombinedArgMatcher
    include ArgMatchProtocol
    attr_reader :all_matchers

    def initialize(options = {})
      @all_matchers = options.fetch(:matchers,[])
    end

    def matches?(args)
      matches = true
      for index in 0..@all_matchers.count - 1
        matches &= @all_matchers[index].matches?(args[index])
        return false unless matches
      end
      matches
    end

    def add(matcher)
      @all_matchers << matcher
    end
    
  end
end
