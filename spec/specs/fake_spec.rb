require 'spec_helper'

module Fakes
  describe Fake do
    context "when stubbing a method" do
      let(:invocations){Hash.new}
      let(:sut){Fake.new(invocations)}
      let(:symbol){:hello}
      let(:new_method){Object.new}

      context "and the method is not currently setup to be called" do
        before (:each) do
          MethodStub.stub(:new).and_return(new_method)
        end
        before (:each) do
          @result = sut.stub(symbol)
        end
        it "should add a new method stub to the list of all invocations" do
          invocations[symbol].should == new_method
        end
        it "should return the method invocation to continue specifying call behaviour" do
          @result.should == new_method 
        end
      end

      context "and the method is already in the list of invocations" do
        before (:each) do
          invocations[symbol] = new_method
        end
        before (:each) do
          @result = sut.stub(symbol)
        end

        it "should not readd the method to the list of invocations" do
          invocations.count.should == 1
        end

        it "should return the method invocation to continue specifying call behaviour" do
          @result.should == new_method 
        end
      end
    end
    context "when accessing the behaviour for a received call" do
      let(:invocations){Hash.new}
      let(:sut){Fake.new(invocations)}
      let(:symbol){:hello}
      let(:method_invocation){Object.new}

      before (:each) do
        invocations[symbol] = method_invocation
      end
      before (:each) do
        @result = sut.received(symbol)
      end
      it "should return the method invocation for the called method" do
        @result.should == method_invocation 
      end
    end
    context "when verifying whether a call was never received" do
      let(:invocations){Hash.new}
      let(:sut){Fake.new(invocations)}
      let(:existing){:hello}
      let(:method_invocation){Object.new}

      before (:each) do
        invocations[existing] = method_invocation
      end


      it "should base its decision on the list of received invocations" do
        [:other,existing].each do|item|
          sut.never_received?(item).should_not be_equal(invocations.has_key?(item))
        end
      end
    end
    context "when method missing is triggered" do
      class FakeInvocation
        attr_accessor :invoke_was_called,:args,:return_value,:ignores_args

        def initialize(return_value)
          @return_value = return_value
        end

        def invoke(args)
          @args = args
          return @return_value
        end

        def ignore_arg
          @ignores_args = true
        end
      end
      let(:invocations){Hash.new}
      let(:sut){Fake.new(invocations)}
      let(:symbol){:hello}
      let(:invocation){FakeInvocation.new(Object.new)}
      let(:args){"world"}
      context "and the method is for an invocation that was prepared" do
        before (:each) do
          invocations[symbol] = invocation
        end
        before (:each) do
          @result = sut.hello(args)
        end
        it "should trigger the invocation with the arguments" do
          invocation.args.should == [args]
        end
        it "should return the result of triggering the invocation" do
          @result.should == invocation.return_value
        end
      end
      context "and the method is for an invocation that was not prepared" do
        before (:each) do
          MethodStub.stub(:new).and_return(invocation)
        end
        before (:each) do
          @result = sut.hello(args)
        end
        it "should add a new invocation which ignores arguments to the list of all invocations" do
          invocations.has_key?(:hello).should be_true
        end

        it "should configure the new invocation to ignore all arguments" do
          invocation.ignores_args.should be_true 
        end

        it "should invoke the invocation with the arguments" do
          invocation.args.should == [args]
        end

        it "should return the result of triggering the new invocation" do
          @result.should == invocation.return_value
        end
      end
    end

    context "scenarios" do
      context "setting up return values using argument matchers" do
        it "should be able to intercept on methods using the matches factory" do
          fake = Fake.new

          fake.stub(:hello).with(Matches.regex(/W/)).and_return("Hello World") 
          fake.hello("World").should == "Hello World"
        end
        it "should be able to intercept on methods using combinations of explicit values and matchers" do
          fake = Fake.new

          fake.stub(:hello).with(Matches.regex(/W/),Matches.greater_than(3),10).and_return("Hello World") 

          fake.hello("World",4,10).should == "Hello World"
          fake.hello("World",2,10).should == nil
        end
      end
      context "setting up return values" do
        it "should be able to intercept on methods that take a singular value" do
          fake = Fake.new
          fake.stub(:hello).with("World").and_return("Hello World") 
          fake.hello("World").should == "Hello World"
        end

        it "should be able to intercept on methods that take a hash" do
          fake = Fake.new
          fake.stub(:hello).with(:id => "JP",:age => 33).and_return("Hello World") 
          fake.hello(:id => "JP",:age => 33).should == "Hello World"
        end

        it "should be able to intercept on methods that take a value and a hash" do
          fake = Fake.new
          fake.stub(:hello).with(1,:id => "JP",:age => 33).and_return("Hello World") 

          fake.hello(1,:id => "JP",:age => 33).should == "Hello World"
          fake.hello(2,:id => "JP",:age => 33).should be_nil
        end

        it "should be able to intercept on methods that take an array" do
          fake = Fake.new
          fake.stub(:hello).with([1,2,3,4]).and_return("Hello World") 

          fake.hello([1,2,3,4]).should == "Hello World"
        end

        it "should be able to intercept on methods that take an value, and an array" do
          fake = Fake.new
          fake.stub(:hello).with(1,[1,2,3,4]).and_return("Hello World") 

          fake.hello(1,[1,2,3,4]).should == "Hello World"
        end
      end
      context "verifying calls were made" do
        it "should be able to intercept on methods that take a singular value" do
          fake = Fake.new
          fake.hello("World")
          fake.received(:hello).called_with("World").should be_true
        end

        it "should be able to intercept on methods that have no arguments" do
          fake = Fake.new
          fake.hello
          fake.received(:hello).should_not be_nil
        end


        it "should be able to intercept on methods that take a hash" do
          fake = Fake.new
          fake.hello(:id => "JP",:age => 33)
          fake.received(:hello).called_with(:id => "JP",:age => 33).should_not be_nil
          fake.received(:hello).called_with(:id => "JS",:age => 33).should be_nil
        end

        it "should be able to intercept on methods that take a value and a hash" do
          fake = Fake.new

          fake.hello(1,:id => "JP",:age => 33)
          fake.received(:hello).called_with(1,:id => "JP",:age => 33).should_not be_nil
          fake.received(:hello).called_with(1,:id => "JS",:age => 33).should be_nil
        end

        it "should be able to intercept on methods that take an array" do
          fake = Fake.new

          fake.hello([1,2,3,4])
          fake.received(:hello).called_with([1,2,3,4]).should_not be_nil
          fake.received(:hello).called_with([1,2,3,5]).should be_nil
        end

        it "should be able to intercept on methods that take an value, and an array" do
          fake = Fake.new
          fake.hello(1,[1,2,3,4])

          fake.received(:hello).called_with(1,[1,2,3,4]).should_not be_nil
          fake.received(:hello).called_with(1,[1,2,3,5]).should be_nil
        end

      end
    end
  end
end
