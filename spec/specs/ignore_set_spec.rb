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
          sut.matches?(1,2,3,4).should be_true
          sut.matches?(3,"hello",4,5).should be_true
        end
      end
    end

  end
end
