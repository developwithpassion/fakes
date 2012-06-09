require 'spec_helper'

module Fakes
  describe BlockArgMatcher do
    context "when determining if it matches a value" do
      let(:sut){BlockArgMatcher.new(lambda{|item| true})}
      
      it "should decide by using its provided block" do
        sut.matches?(2).should be_true
      end
    end
  end
  
end
