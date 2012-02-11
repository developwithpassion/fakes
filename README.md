#developwithpassion_fakes

This is a really simple library to aid in AAA style testing. The primary driver for using this is to be able to make assertions on method calls to collaborators in actual assertions and not as part of setup.

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

To create a new fake, simple instantiate a class of DevelopWithPassion::Fakes::Fake. If you don't wish to keep typing that out, I would recommend creating a simple factory method in your test utility file. I typically use a file called spec_helper that is included in all of the test files. I will place the following code in spec_helper (sample) :

```ruby
require 'rspec'
require 'developwithpassion_fakes'

def fake
  return DevelopWithPassion::Fakes::Fake.new
end
```
As you can see, this makes the process of creating a fake much simpler from a test.

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

####Setup a return value for 1
collaborator.stub(:method).with(1).and_return(first_return_value)
####Setup a return value for 2
collaborator.stub(:method).with(2).and_return(second_return_value)
####Setup a return value when called with everything else
collaborator.stub(:method).and_return(value_to_return_with_arguments_other_than_1_and_2)
```
If you are going to mix different arguments with different return values as well as have the "ignored" set returning a default, make sure the ignore arguments behaviour is specified last (as in the example above)
