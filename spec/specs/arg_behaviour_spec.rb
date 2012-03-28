require 'spec_helper'

module Fakes
  describe ArgBehaviour do
    class AnArg
      attr_accessor :called_args,:args
      def initialize
        @times_called = 0
      end
    end

    let(:sut){AnArg.new}
    before (:each) do
      sut.send(:extend,ArgBehaviour)
    end
    context "when a return value is specified" do
      before (:each) do
        sut.and_return(2)
      end
      it "should store the return value to be returned during invocation" do
        sut.return_value.should == 2
      end
    end

    context "when handling an invocation" do
      before (:each) do
        sut.capture_args(2)
      end
      it "should increment the number of times it was called" do
        sut.times_called.should == 1
      end
      it "should store the arguments it was called with" do
        sut.called_args.should == 2
      end
    end

    context "when matching a set of arguments" do
      before (:each) do
        sut.args = 2
      end
      it "should match if its own set of arguments are the same" do
        sut.matches?(2).should be_true
        sut.matches?(3).should be_false
      end
    end

    context "when matching a set of arguments that is passed in as a dictionary" do
      before (:each) do
        sut.args = {:id => 0,:name => "JP"}
      end
      it "should match if its hash is the same" do
        sut.matches?(:id => 0,:name => "JP").should be_true
      end
    end

    context "when determining whether it was called with a set of arguments" do
      before (:each) do
        sut.called_args = 2
      end

      it "should match if the arguments are the same as the arguments it was invoked with" do
        sut.was_called_with?(2).should be_true
        sut.was_called_with?(3).should be_false
      end
    end
  end
end
