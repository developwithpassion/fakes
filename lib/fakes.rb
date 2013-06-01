require 'core/arg_matching/arg_match_factory'
require 'core/arg_matching/block_arg_matcher'
require 'core/arg_matching/combined_arg_matcher'
require 'core/arg_matching/matches'
require 'core/arg_matching/regular_arg_matcher'
require 'core/arg_behaviour'
require 'core/arg_set'
require 'core/class_swap'
require 'core/class_swaps'
require 'core/fake'
require 'core/ignore_set'
require 'core/method_stub'
require 'singleton'

module Fakes
  def fake(invocations = {})
    item = Fakes::Fake.new
    invocations.each{|method,return_value| item.stub(method).and_return(return_value)}
    item
  end
  def arg_match
    return Fakes::Matches
  end
  def fake_class(klass,invocations = {})
    item = fake(invocations)
    Fakes::ClassSwaps.instance.add_fake_for(klass,item)
    item
  end
  def reset_fake_classes
    Fakes::ClassSwaps.instance.reset
  end
end

include Fakes
