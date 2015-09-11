module Fakes
  class Fake
    def initialize(invocation_set = {})
      @method_invocations = invocation_set
    end

    def method_missing(name, *args, &block)
      @method_invocations.key?(name.to_sym) ? @method_invocations[name.to_sym].invoke(args) : handle_unexpected_method_invocation(name, args, block)
    end

    def send(name, *args, &block)
      method_missing(name, *args, &block)
    end

    def handle_unexpected_method_invocation(name, args, _block)
      method = stub(name.to_sym)
      method.ignore_arg
      method.invoke(args)
    end

    def stub(symbol)
      @method_invocations[symbol] || @method_invocations[symbol] = MethodStub.new
    end

    def received(symbol)
      @method_invocations[symbol]
    end

    def never_received?(symbol, *args)
      !received?(symbol, *args)
    end

    def received?(symbol, *args)
      method = received(symbol)
      return false if method.nil?

      argument_set = method.called_with(*args)
      !argument_set.nil?
    end
  end
end
