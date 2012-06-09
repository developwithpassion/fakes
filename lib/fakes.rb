require 'developwithpassion_arrays'

require 'core/arg_behaviour'
require 'core/arg_match_factory'
require 'core/arg_match_protocol'
require 'core/arg_set'
require 'core/block_arg_matcher'
require 'core/combined_arg_matcher'
require 'core/fake'
require 'core/ignore_set'
require 'core/method_stub'
require 'core/regular_arg_matcher'

module Kernel
  def fake
    return Fakes::Fake.new
  end
end
