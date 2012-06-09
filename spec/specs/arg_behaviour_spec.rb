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
    context "when continuing its execution" do
      context "and no exception has been specified to be thrown" do
        before (:each) do
          sut.and_return(2)
        end
        it "should store the return value to be returned during invocation" do
          sut.process().should == 2
        end
      end
      context "and an exception has been specified to be thrown" do
        let(:exception){Exception.new}
        before (:each) do
          sut.throws(exception)
        end
        it "should throw the exception" do
          begin
            sut.process()
          rescue Exception => e
            e.should == exception
          end
        end
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
      let(:matcher){Object.new}
      before (:each) do
        sut.arg_matcher = matcher

        matcher.stub(:matches?).with(2).and_return(true)
        matcher.stub(:matches?).with(3).and_return(false)
      end
      it "should match if its argument matcher matches the argument set" do
        sut.matches?(2).should be_true
        sut.matches?(3).should be_false
      end
    end


    context "when determining whether it was called with a set of arguments" do
      let(:the_matcher){Object.new}

      before (:each) do
        ArgMatchFactory.stub(:create_arg_matcher_using).with(2).and_return(the_matcher)
        the_matcher.stub(:matches?).with(2).and_return(true)
      end
      
      before (:each) do
        sut.called_args = 2
      end

      it "should make the decision by using the matcher created to match the arguments" do
        sut.was_called_with?(2).should be_true
      end
    end
  end
end
