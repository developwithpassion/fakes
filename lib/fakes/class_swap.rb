module Fakes
  class ClassSwap
    attr_accessor :original,:replacement
    attr_reader :klass

    def initialize(fully_qualified_klass,replacement,options ={})
      modules = get_modules(fully_qualified_klass)
      @klass = modules.keys.last.to_sym

      class_root = modules.keys[modules.keys.count - 2]
      class_root = modules[class_root.to_sym]

      @replacement = replacement

      @remove_strategy = options.fetch(:remove_strategy, Proc.new do |klass| 
        class_root.send(:remove_const, klass)
      end)

      @set_strategy = options.fetch(:set_strategy, Proc.new do |klass, new_value|
        class_root.const_set(klass.to_sym, new_value)
      end)

    end
    
    def get_modules(fully_qualified_klass)
      klass_parts = fully_qualified_klass.to_s.split("::")
      root = Object
      modules = {}
      modules[:Object] = root

      klass_parts.each do |part|
        class_or_module = root.const_get(part.to_sym)
        modules[part.to_sym] = class_or_module
        root = class_or_module
      end

      modules
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
