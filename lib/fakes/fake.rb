module Fakes
  class Fake
    def initialize(invocation_set = {})
      @method_invocations = invocation_set
    end

    def method_missing(name,*args,&block)
      return @method_invocations.has_key?(name.to_sym) ? @method_invocations[name.to_sym].invoke(args) : handle_unexpected_method_invocation(name,args,block)
    end

    def handle_unexpected_method_invocation(name,args,block)
      method = stub(name.to_sym)
      method.ignore_arg
      return method.invoke(args)
    end

    def stub(symbol)
      return @method_invocations[symbol] || @method_invocations[symbol] = MethodStub.new
    end

    def received(symbol)
      return @method_invocations[symbol]
    end

    def never_received?(symbol)
      return !@method_invocations.has_key?(symbol)
    end
  end
end
