require 'spec_helper'

module Fakes
  describe ArgMatchFactory do
    context "when creating an argument matcher" do
      context "and none of the arguments are matchers themselves" do
        before (:each) do
          @result = ArgMatchFactory.create_arg_matcher_using([2,3,4])
        end
        
        it "should create a combined matcher that is composed of regular matchers" do
          @result.all_matchers.count.should == 3
          @result.all_matchers.each do|matcher|
            matcher.class.should == RegularArgMatcher
          end
        end
      end
      context "and the arguments are matchers themselves" do
        let(:matcher){Object.new}
        before (:each) do
          matcher.stub(:respond_to?).with(:matches?).and_return(true)
        end
        
        before (:each) do
          @result = ArgMatchFactory.create_arg_matcher_using([matcher])
        end
        
        it "should create a combined matcher that only using the matchers provided" do
          @result.all_matchers.count.should == 1
          @result.all_matchers[0].should == matcher
        end
      end
    end
  end
end
