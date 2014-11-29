require 'spec_helper'

module Fakes
  describe IgnoreSet do
    let(:sut){IgnoreSet.new}

    context "when created" do
      it "should initialize required members" do
        expect(sut.times_called).to eql(0)
      end
    end

    context "when matching an argument set" do
      it "should match any argument set" do
        expect(sut.matches?([1,2,3,4])).to be_true
        expect(sut.matches?([3,"hello",4,5])).to be_true
      end
    end

    context "when capturing a set of arguments" do
      before (:each) do
        sut.capture_args(1)
        sut.capture_args(2)
      end
      it "should store a list for each set of arguments" do
        expect(sut.arg_sets.count).to eql(2)
      end
    end

    context "when determining if it was called with a set of arguments" do
      let(:the_matcher){Object.new}

      before (:each) do
        ArgMatchFactory.stub(:create_arg_matcher_using).with(2).and_return(the_matcher)
        the_matcher.stub(:matches?).with(3).and_return(true)
        the_matcher.stub(:matches?).with(1).and_return(true)
      end
      
      before (:each) do
        sut.capture_args(1)
        sut.capture_args(3)
      end

      it "should make the decision by using the matcher created to match the argument sets that were stored" do
        expect(sut.was_called_with?(2)).to be_true
      end
    end
  end

end
