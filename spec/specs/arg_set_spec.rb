require 'spec_helper'

module DevelopWithPassion
  module Fakes
    describe ArgSet do
      context "when created" do
        let(:sut){ArgSet.new(1)}

        it "should initialize required members" do
          sut.times_called.should == 0
        end
      end
    end
  end
end
