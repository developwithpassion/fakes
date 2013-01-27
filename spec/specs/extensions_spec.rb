require 'spec_helper'

describe Fakes do
  it "should be able to create a new fake" do
    fake.class.should == Fakes::Fake 
  end
  it "should be able to create a new fake and specify return values for methods" do
    item = fake :hello => 'World', :age => 33
    item.hello.should == 'World'
    item.age.should == 33
  end

  context "when specifying a fake for a class" do
    let(:swaps){fake}
    before (:each) do
      Fakes::ClassSwaps.stub(:instance).and_return(swaps)
    end
    before (:each) do
      @result = fake_class Dir
    end
    
    it "should register a new fake with the class swaps" do
      swaps.received(:add_fake_for).called_with(Dir,arg_match.not_nil).should_not be_nil
    end

    it "should return the newly created fake" do
      @result.should_not be_nil
    end
  end
  context "when faking a class and specifying return values" do
    before (:each) do
      fake_class Dir,:exist? => true
    end
    after (:each) do
      reset_fake_classes
    end
    it "should replace the class with the fake return to return the values specified" do
      Dir.exist?('hello').should be_true
    end
  end
  
  context "resetting fake classes" do
    let(:swaps){fake}
    before (:each) do
      Fakes::ClassSwaps.stub(:instance).and_return(swaps)
    end
    before (:each) do
      reset_fake_classes
    end
    it "should be able to reset all of the fake classes" do
      swaps.received(:reset)
    end
  end
end

