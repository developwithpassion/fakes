require 'arrayfu'

require 'core/arg_behaviour'
require 'core/arg_set'
require 'core/fake'
require 'core/ignore_set'
require 'core/method_stub'

module Kernel
  def fake
    return Fakes::Fake.new
  end
end
