require 'spec_helper'

module Fakes
  describe RegularArgMatcher do
    context "when determining if it matches a value" do
      let(:sut){RegularArgMatcher.new(2)}
      
      it "should match if the incoming value matches the value it was created to match" do
        expect(sut.matches?(2)).to be_true
        expect(sut.matches?(3)).to be_false
      end
    end
  end
  
end
