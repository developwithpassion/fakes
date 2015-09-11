module Fakes
  def fake(invocations = {})
    item = Fake.new
    invocations.each { |method, return_value| item.stub(method).and_return(return_value) }
    item
  end

  def arg_match
    ArgumentMatching
  end

  def fake_class(klass, invocations = {})
    item = fake(invocations)
    ClassSwaps.instance.add_fake_for(klass, item)
    item
  end

  def reset_fake_classes
    ClassSwaps.instance.reset
  end
end
