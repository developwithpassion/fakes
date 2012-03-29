require 'arrayfu'

require 'fakes/arg_behaviour'
require 'fakes/arg_set'
require 'fakes/fake'
require 'fakes/ignore_set'
require 'fakes/method_stub'

module Kernel
  def fake
    return Fakes::Fake.new
  end
end
