require 'developwithpassion_arrays'
require 'developwithpassion_fakes/arg_behaviour'
require 'developwithpassion_fakes/arg_set'
require 'developwithpassion_fakes/fake'
require 'developwithpassion_fakes/ignore_set'
require 'developwithpassion_fakes/method_stub'

module Kernel
  def fake
    return DevelopWithPassion::Fakes::Fake.new
  end
end
