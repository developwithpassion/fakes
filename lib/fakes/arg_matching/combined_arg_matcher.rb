module Fakes
  class CombinedArgMatcher
    attr_reader :all_matchers

    def initialize(options = {})
      @all_matchers = options.fetch(:matchers,[])
    end

    def matches?(args)
      matches = true

      all_matchers.each_with_index do |matcher, index|
        value = args[index]
        matches &= matcher.matches?(value)
        return false unless matches
      end

      matches
    end

    def add(matcher)
      all_matchers << matcher
    end
    alias :<< :add
    
  end
end
