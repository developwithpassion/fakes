require 'developwithpassion_arrays'

require 'core/arg_matching/arg_match_factory'
require 'core/arg_matching/arg_match_protocol'
require 'core/arg_matching/block_arg_matcher'
require 'core/arg_matching/combined_arg_matcher'
require 'core/arg_matching/matches'
require 'core/arg_matching/regular_arg_matcher'
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
