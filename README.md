#developwithpassion_fakes

This is a really simple library to aid in AAA style testing. The primary driver for using this is to be able to make assertions on method calls to collaborators in actual assertions and not as part of setup. It is meant to be used to complement the current testing framework that you are using to aid in the creation of interaction based tests.

Here is a simple example

```ruby
class SomeClass
  def initialize(collaborator)
    @collaborator = collaborator
  end
  def run()
    @collaborator.send_message("Hi")
  end
end

describe SomeClass do
 context "when run" do
  let(:collaborator){DevelopWithPassion::Fakes::Fake.new}
  let(:sut){SomeClass.new(collaborator)}

  before(:each) do
    sut.run
  end

  it "should trigger its collaborator with the correct message" do
    collaborator.received(:send_message).called_with("Hi").should_not be_nil
  end
 end
end
```

##Creating a new fake

To create a new fake, simply leverage the fake method that is mixed into the Kernel module.

```ruby
require 'developwithpassion_fakes'

item = fake
```

##Specifying the behaviour of a fake

When scaffolding fake return values, the library behaves almost identically to the way RSpec stubs work. 

###Setup a method to return a value for a particular set of arguments
```ruby
collaborator = fake

collaborator.stub(:name_of_method).with(arg1,arg2,arg3).and_return(return_value)
```

###Setup a method to return a value regardless of the arguments it is called with
```ruby
collaborator = fake

#long handed way
collaborator.stub(:name_of_method).ignore_arg.and_return(return_value)

#preferred way
collaborator.stub(:name_of_method).and_return(return_value)
```

###Setup different return values for different argument sets
```ruby
collaborator = fake

#Setup a return value for 1
collaborator.stub(:method).with(1).and_return(first_return_value)

#Setup a return value for 2
collaborator.stub(:method).with(2).and_return(second_return_value)

#Setup a return value when called with everything else 
#if you are going to use this, make sure it is used after 
#setting up return values for specific arguments
collaborator.stub(:method).and_return(value_to_return_with_arguments_other_than_1_and_2)
```

##Verifying calls made to the fake


###Verifying when a call was made

The primary purpose of the library is to help you in doing interaction style testing in a AAA style. Assume the following class is one you would like to test:

```ruby
class ItemToTest
  def initialize(collaborator)
    @collaborator = collaborator
  end

  def run
    @collaborator.send_message("Hello World")
  end
end
```

ItemToTest is supposed to leverage its collaborator and calls its send_message method with the argument "Hello World". To verify this using AAA style, interaction testing you can do the following (I am using rspec, but you can use this with any testing library you wish):

```ruby
describe ItemToTest do
 context "when run" do
  let(:collaborator){fake}
  let(:sut){ItemToTest.new(collaborator)}

  #I typically use a before block to specifically trigger the method that I am testing, so it cleanly
  #separates it from the assertions I will make later
  before(:each) do
    sut.run
  end

  it "should trigger its collaborator with the correct message" do
    collaborator.received(:send_message).called_with("Hello World").should_not be_nil
  end
 end
end
```
From the example above, you can see that we created the fake and did not need to scaffold it with any behaviour. 

```ruby
let(:collaborator){fake}
```

You can also see that we are create our System Under Test (sut) and provide it the collaborator:

```ruby
let(:sut){ItemToTest.new(collaborator)}
```

We then proceed to invoke the method on the component we are testing

```ruby
before(:each) do
  sut.run
end
```

Last but not least, we verify that our collaborator was invoked and with the right arguments:

```ruby
it "should trigger its collaborator with the correct message" do
  collaborator.received(:send_message).called_with("Hello World").should_not be_nil
end
```

The nice thing is we can make the assertions after the fact, as opposed to needing to do them as part of setup, which I find is a much more natural way to read things, when you need to do this style of test. Notice that the called_with method return a method_invocation that will be nil if the call was not received. My recommendation would be to create a test utility method that allows you to leverage your testing frameworks assertion library to make the above assertion more terse. The
following rspec sample demonstrates:

```ruby
module RSpec
  Matchers.define :have_received do|symbol,*args|
    match do|fake|
      fake.received(symbol).called_with(*args) != nil
    end
  end
end
```

Using the above utility method turns the previous assertion:

```ruby
collaborator.received(:send_message).called_with("Hello World").should_not be_nil
```

To this:

```ruby
collaborator.should have_received(:send_message,"Hello World")
```

###Verifying that a call should not have been made

Currently verifying that a call was not made does not take the arguments into consideration. It just ensures that no calls to a particular named method were made. Here is an example:

```ruby
class FirstCollaborator
  def send_message(message)
  end
end
class SecondCollaborator
  def send_message(message)
  end
end

class SomeItem
  def initialize
    @first = FirstCollaborator.new
    @second = SecondCollaborator.new
  end

  def first_behaviour
    @first.send_message("Hello")
  end

  def second_behaviour
    @second.send_message("World")
  end
end

describe SomeItem do
 context "when run" do
  let(:first){fake}
  let(:second){fake}

  before(:each) do
    FirstCollaborator.stub(:new).and_return(first)
    SecondCollaborator.stub(:new).and_return(second)
    @sut = SomeItem.new
  end

  before(:each) do
    @sut.first_behaviour
  end

  it "should trigger its collaborator with the correct message" do
    first.should have_received(:send_message,"Hello")
  end

  it "should not trigger its second collaborator" do
    #again, here would be another option to use a convienience test utility method
    second.never_received?(:send_message).should be_true
  end
 end
end
```

As you can see, in this test we want to verify that one collaborator was triggered and the other not.
