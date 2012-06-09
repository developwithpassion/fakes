require 'spec_helper'

module Fakes
  describe RegularArgMatcher do
    context "when determining if it matches a value" do
      let(:sut){RegularArgMatcher.new(2)}
      
      it "should match if the incoming value matches the value it was created to match" do
        sut.matches?(2).should be_true
        sut.matches?(3).should be_false
      end
    end
  end
  
end
