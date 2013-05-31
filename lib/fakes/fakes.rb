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

