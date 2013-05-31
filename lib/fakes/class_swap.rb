module Fakes
  class ClassSwap
    attr_accessor :original,:replacement
    attr_reader :klass

    def initialize(fully_qualified_klass,replacement,options ={})
      klass_parts = fully_qualified_klass.to_s
      parts = klass_parts.split('::')
      the_module = parts.count == 1 ? Object : eval(parts.slice(0,parts.count - 1).join('::'))
      @klass = parts[parts.count - 1].to_s.to_sym

      @replacement = replacement
      @remove_strategy = options.fetch(:remove_strategy,lambda{|klass_symbol| the_module.send(:remove_const,klass_symbol)})
      @set_strategy = options.fetch(:set_strategy,lambda{|klass_symbol,new_value| the_module.const_set(klass_symbol,new_value)})
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
