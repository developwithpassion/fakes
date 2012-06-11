module Fakes
  class ClassSwap
    attr_accessor :original,:replacement
    attr_reader :klass

    def initialize(klass,replacement,options ={})
      @klass = klass.to_s.to_sym
      @replacement = replacement
      @remove_strategy = options.fetch(:remove_strategy,lambda{|klass_symbol| Object.send(:remove_const,klass_symbol)})
      @set_strategy = options.fetch(:set_strategy,lambda{|klass_symbol,new_value| Object.const_set(klass_symbol,new_value)})
    end

    def initiate
      swap_to(replacement){|original| @original = original}
    end

    def reset
      swap_to(@original)
    end

    def swap_to(new_value,&block)
      current = @remove_strategy.call(@klass)
      yield current if block_given?
      @set_strategy.call(@klass,new_value)
    end
  end
end
