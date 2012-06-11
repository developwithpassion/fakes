require 'spec_helper'

describe Object do
  it "should be able to create a new fake" do
    fake.class.should == Fakes::Fake 
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

