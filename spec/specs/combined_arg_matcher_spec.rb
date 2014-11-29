require 'spec_helper'

module Fakes
  describe CombinedArgMatcher do
    context "when determining whether it matches an set of arguments" do
      let(:args){[2,3]}
      let(:first_matcher){Object.new}
      let(:second_matcher){Object.new}
      let(:matchers){[first_matcher,second_matcher]}
      let(:options){{:matchers => matchers}}
      let(:sut){CombinedArgMatcher.new(options)}
      before (:each) do
        first_matcher.stub(:matches?).with(2).and_return(3)
        second_matcher.stub(:matches?).with(3).and_return(3)
      end
      
      
      before (:each) do
        @result = sut.matches?(args)
      end
      
      
      it "should match if each of its argument matchers matches its respective argument" do
        expect(@result).to be_true
      end
    end
    context "when adding a matcher" do
      let(:first_matcher){Object.new}
      let(:matchers){[]}
      let(:options){{:matchers => matchers}}
      let(:sut){CombinedArgMatcher.new(options)}
      
      before (:each) do
        sut.add(first_matcher)
      end
      
      
      it "should add the matcher to its set of matchers" do
        expect(matchers[0]).to eql(first_matcher)
      end
    end
  end
end

