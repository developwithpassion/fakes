require 'singleton'

module Fakes
  class ClassSwaps
    include Singleton
    attr_reader :swaps

    def initialize
      @swaps = {}
    end

    def add_fake_for(klass,the_fake)
      symbol = klass.to_s.to_sym
      ensure_swap_does_not_already_exist_for(symbol)
      swap = ClassSwap.new(klass,the_fake)
      @swaps[symbol] = swap
      swap.initiate
    end

    def ensure_swap_does_not_already_exist_for(symbol)
      raise "A swap already exists for the class #{symbol}" if @swaps.has_key?(symbol)
    end

    def reset
      @swaps.values.each{|item| item.reset}
      @swaps.clear
    end
  end
end
