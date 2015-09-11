require 'spec_helper'

module Fakes
  describe ArgMatchFactory do
    context 'when creating an argument matcher' do
      context 'and none of the arguments are matchers themselves' do
        before (:each) do
          @result = ArgMatchFactory.create_arg_matcher_using([2, 3, 4])
        end

        it 'should create a combined matcher that is composed of regular matchers' do
          expect(@result.all_matchers.count).to eql(3)

          @result.all_matchers.each do|matcher|
            expect(matcher.class).to eql(RegularArgMatcher)
          end
        end
      end
      context 'and the arguments are matchers themselves' do
        let(:matcher) { Object.new }
        before (:each) do
          matcher.stub(:respond_to?).with(:matches?).and_return(true)
        end

        before (:each) do
          @result = ArgMatchFactory.create_arg_matcher_using([matcher])
        end

        it 'should create a combined matcher that only using the matchers provided' do
          expect(@result.all_matchers.count).to eql(1)
          expect(@result.all_matchers[0]).to eql(matcher)
        end
      end
    end
  end
end
