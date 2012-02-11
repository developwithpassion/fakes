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
    collaborator.received("send_message").called_with("Hi").should be_true
  end
 end
end
  
```
