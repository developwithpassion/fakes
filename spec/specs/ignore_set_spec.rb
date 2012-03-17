require 'spec_helper'

module DevelopWithPassion
  module Fakes
    describe IgnoreSet do
      let(:sut){IgnoreSet.new}

      context "when created" do
        it "should initialize required members" do
          sut.times_called.should == 0
        end
      end

      context "when matching an argument set" do
        it "should match any argument set" do
          sut.matches?([1,2,3,4]).should be_true
          sut.matches?([3,"hello",4,5]).should be_true
        end
      end

      context "when capturing a set of arguments" do
        before (:each) do
          sut.capture_args(1)
          sut.capture_args(2)
        end
        it "should store a list for each set of arguments" do
          sut.arg_sets.count.should == 2
        end
      end

      context "when determining if it was called with a set of arguments" do
        before (:each) do
          sut.capture_args(1)
          sut.capture_args(2)
        end
        it "should match if any of its argument sets match" do
          sut.was_called_with?(2).should be_true
        end
      end
    end

  end
end
