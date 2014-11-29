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
          expect(invocations[symbol]).to eql(new_method)
        end
        it "should return the method invocation to continue specifying call behaviour" do
          expect(@result).to eql(new_method )
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
          expect(invocations.count).to eql(1)
        end

        it "should return the method invocation to continue specifying call behaviour" do
          expect(@result).to eql(new_method )
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
        expect(@result).to eql(method_invocation )
      end
    end
    context "when verifying whether a call was never received" do
      let(:invocations){Hash.new}
      let(:sut){Fake.new(invocations)}
      let(:existing){:hello}
      let(:method_invocation){ Object.new }

      before (:each) do
        invocations[existing] = method_invocation
        method_invocation.stub(:called_with).and_return(false)
      end


      it "should base its decision on the list of received invocations" do
        [:other, existing].each do|item|
          expect(sut.never_received?(item)).to_not be_equal(invocations.has_key?(item))
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
          expect(invocation.args).to eql([args])
        end
        it "should return the result of triggering the invocation" do
          expect(@result).to eql(invocation.return_value)
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
          expect(invocations.has_key?(:hello)).to be_true
        end

        it "should configure the new invocation to ignore all arguments" do
          expect(invocation.ignores_args).to be_true
        end

        it "should invoke the invocation with the arguments" do
          expect(invocation.args).to eql([args])
        end

        it "should return the result of triggering the new invocation" do
          expect(@result).to eql(invocation.return_value)
        end
      end
    end

    context "when send is triggered" do
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
          @result = sut.send(:hello,args)
        end
        it "should trigger the invocation with the arguments" do
          expect(invocation.args).to eql([args])
        end
        it "should return the result of triggering the invocation" do
          expect(@result).to eql(invocation.return_value)
        end
      end
      context "and the method is for an invocation that was not prepared" do
        before (:each) do
          MethodStub.stub(:new).and_return(invocation)
        end
        before (:each) do
          @result = sut.send(:hello,args)
        end
        it "should add a new invocation which ignores arguments to the list of all invocations" do
          expect(invocations.has_key?(:hello)).to be_true
        end

        it "should configure the new invocation to ignore all arguments" do
          expect(invocation.ignores_args).to be_true
        end

        it "should invoke the invocation with the arguments" do
          expect(invocation.args).to eql([args])
        end

        it "should return the result of triggering the new invocation" do
          expect(@result).to eql(invocation.return_value)
        end
      end
    end

    context "scenarios" do
      context "setting up return values using argument matchers" do
        it "should be able to intercept on methods using the matches factory" do
          fake = Fake.new

          fake.stub(:hello).with(ArgumentMatching.regex(/W/)).and_return("Hello World") 
          expect(fake.hello("World")).to eql("Hello World")
        end
        it "should be able to intercept on methods using combinations of explicit values and matchers" do
          fake = Fake.new

          fake.stub(:hello).with(ArgumentMatching.regex(/W/),ArgumentMatching.greater_than(3),10).and_return("Hello World") 

          expect(fake.hello("World",4,10)).to eql("Hello World")
          expect(fake.hello("World",2,10)).to be_nil
        end
      end
      context "setting up return values" do
        it "should be able to intercept on methods that take a singular value" do
          fake = Fake.new
          fake.stub(:hello).with("World").and_return("Hello World") 
          expect(fake.hello("World")).to eql("Hello World")
        end

        it "should be able to intercept on methods that take a hash" do
          fake = Fake.new
          fake.stub(:hello).with(:id => "JP",:age => 33).and_return("Hello World") 
          expect(fake.hello(:id => "JP",:age => 33)).to eql("Hello World")
        end

        it "should be able to intercept on methods that take a value and a hash" do
          fake = Fake.new
          fake.stub(:hello).with(1,:id => "JP",:age => 33).and_return("Hello World") 

          expect(fake.hello(1,:id => "JP",:age => 33)).to eql("Hello World")
          expect(fake.hello(2,:id => "JP",:age => 33)).to be_nil
        end

        it "should be able to intercept on methods that take an array" do
          fake = Fake.new
          fake.stub(:hello).with([1,2,3,4]).and_return("Hello World") 

          expect(fake.hello([1,2,3,4])).to eql("Hello World")
        end

        it "should be able to intercept on methods that take an value, and an array" do
          fake = Fake.new
          fake.stub(:hello).with(1,[1,2,3,4]).and_return("Hello World") 

          expect(fake.hello(1,[1,2,3,4])).to eql("Hello World")
        end
      end
      context "verifying calls were made" do
        it "should be able to intercept on methods that take a singular value" do
          fake = Fake.new
          fake.hello("World")
          expect(fake.received(:hello).called_with("World")).to be_true
        end

        it "should be able to intercept on methods that have no arguments" do
          fake = Fake.new
          fake.hello
          expect(fake.received(:hello)).to_not be_nil
        end


        it "should be able to intercept on methods that take a hash" do
          fake = Fake.new
          fake.hello(:id => "JP",:age => 33)
          expect(fake.received(:hello).called_with(:id => "JP",:age => 33)).to_not be_nil
          expect(fake.received(:hello).called_with(:id => "JS",:age => 33)).to be_nil
        end

        it "should be able to intercept on methods that take a value and a hash" do
          fake = Fake.new

          fake.hello(1,:id => "JP",:age => 33)
          expect(fake.received(:hello).called_with(1,:id => "JP",:age => 33)).to_not be_nil
          expect(fake.received(:hello).called_with(1,:id => "JS",:age => 33)).to be_nil
        end

        it "should be able to intercept on methods that take an array" do
          fake = Fake.new

          fake.hello([1,2,3,4])
          expect(fake.received(:hello).called_with([1,2,3,4])).to_not be_nil
          expect(fake.received(:hello).called_with([1,2,3,5])).to be_nil
        end

        it "should be able to intercept on methods that take an value, and an array" do
          fake = Fake.new
          fake.hello(1,[1,2,3,4])

          expect(fake.received(:hello).called_with(1,[1,2,3,4])).to_not be_nil
          expect(fake.received(:hello).called_with(1,[1,2,3,5])).to be_nil
        end

        it 'should be able to determine if it received a method call' do
          fake = Fake.new
          fake.hello(1,[1,2,3,4])

          expect(fake.received?(:hello,1,[1,2,3,4])).to be_true
          expect(fake.received?(:hello)).to be_true
        end
      end
      context 'running a block when a call is made' do
        it 'runs the block with arguments provided and returns value of the block' do
          fake = Fake.new

          fake.stub(:hello).run do |name|
            expect(name).to eql('JP')
            2
          end

          result = fake.hello('JP')

          expect(result).to eql(2)
        end
      end
    end
  end
end
