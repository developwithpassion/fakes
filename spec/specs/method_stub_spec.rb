require 'spec_helper'

module Fakes
  describe MethodStub do
    let(:args) { [1, 2, 3] }
    let(:argument_set) { Object.new }

    context 'when specifying a set of arguments it should be called with' do
      let(:arg_sets) { [] }
      let(:sut) { MethodStub.new(arg_sets) }

      before (:each) do
        ArgSet.stub(:new).with([args]).and_return(argument_set)
      end
      before (:each) do
        @result = sut.with(args)
      end
      it 'should add a new argument set to its list of arguments' do
        expect(arg_sets[0]).to eql(argument_set)
      end
      it 'should return the argument set to continue specifying behaviour' do
        expect(@result).to eql(argument_set)
      end
    end

    context 'when ignoring arguments' do
      let(:ignored_set) { Object.new }
      let(:arg_sets) { [] }
      let(:sut) { MethodStub.new(arg_sets) }

      before (:each) do
        IgnoreSet.stub(:new).and_return(ignored_set)
      end
      before (:each) do
        @result = sut.ignore_arg
      end
      it 'should add the ignored set to the list of argument sets' do
        expect(arg_sets[0]).to eql(ignored_set)
      end
      it 'should return the ignored set to specify other behaviour' do
        expect(@result).to eql(ignored_set)
      end
    end

    context 'when specified to throw an exception' do
      let(:ignored_set) { DummyArgSet.new }
      let(:exception) { Object.new }
      let(:arg_sets) { [] }
      let(:sut) { MethodStub.new(arg_sets) }

      class DummyArgSet
        attr_accessor :exception

        def throws(exception)
          @exception = exception
        end
      end

      before (:each) do
        IgnoreSet.stub(:new).and_return(ignored_set)
      end

      before (:each) do
        sut.throws(exception)
      end
      it 'should add the ignored set to the set of args sets' do
        expect(arg_sets[0]).to eql(ignored_set)
      end
      it 'should have stored the exception on the new argument set' do
        expect(ignored_set.exception).to eql(exception)
      end
    end
    context 'when invoked with a set of arguments' do
      let(:arg_sets) { [] }
      let(:sut) { MethodStub.new(arg_sets) }
      class DummyArgSet
        attr_accessor :args

        def capture_args(*args)
          @args = *args
        end
      end
      context 'and it has the specified argument set' do
        let(:arguments) { [1] }
        let(:arg_set) { DummyArgSet.new }
        before (:each) do
          arg_sets.push(arg_set)
          arg_set.stub(:matches?).and_return(true)
          arg_set.stub(:process).and_return(2)
        end
        before (:each) do
          @result = sut.invoke(arguments)
        end
        it 'should tell the argument set to capture the arguments it was called with' do
          expect(arg_set.args).to eql([arguments])
        end
        it 'should return using from the arg set' do
          expect(@result).to eql(2)
        end
      end
      context 'and it does not have the specified argument set' do
        let(:arguments) { [1] }
        let(:arg_set) { DummyArgSet.new }
        before (:each) do
          sut.stub(:ignore_arg).and_return(arg_set)
          arg_set.stub(:process).and_return(2)
        end
        before (:each) do
          @result = sut.invoke(arguments)
        end
        it 'should tell the argument set to capture the arguments it was called with' do
          expect(arg_set.args).to eql([arguments])
        end
        it 'should return using from the missing arg set' do
          expect(@result).to eql(2)
        end
      end
    end

    context 'when determining whether it was called with a set of arguments' do
      let(:arg_sets) { [] }
      let(:sut) { MethodStub.new(arg_sets) }
      class DummyArgSet
        attr_accessor :args

        def capture_args(*args)
          @args = *args
        end
      end
      let(:arguments) { 1 }

      context 'and one of its argument sets was called with the set of arguments' do
        let(:arg_set) { DummyArgSet.new }
        before (:each) do
          arg_sets.push(arg_set)
          arg_set.stub(:was_called_with?).with([arguments]).and_return(true)
        end
        before (:each) do
          @result = sut.called_with(arguments)
        end

        it 'should return the argument set that was called with the arguments' do
          expect(@result).to eql(arg_set)
        end
      end
      context 'and none of its argument sets were called with the arguments' do
        before (:each) do
          @result = sut.called_with(arguments)
        end
        it 'should return nil' do
          expect(@result).to be_nil
        end
      end
    end

    context 'when retrieving the total number of times called' do
      let(:arg_sets) { [] }
      let(:sut) { MethodStub.new(arg_sets) }
      let(:arg_set) { DummyArgSet.new }
      let(:arg_set_2) { DummyArgSet.new }

      before (:each) do
        arg_sets.push(arg_set)
        arg_sets.push(arg_set_2)
        arg_set.stub(:times_called).and_return(2)
        arg_set_2.stub(:times_called).and_return(3)
      end

      it 'it should return the sum of the invocations of its argument sets' do
        expect(sut.total_times_called).to eql(5)
      end
    end
    context 'when verifying whether it was called a certain number of times' do
      let(:arg_sets) { [] }
      let(:sut) { MethodStub.new(arg_sets) }
      let(:arg_set) { DummyArgSet.new }
      let(:arg_set_2) { DummyArgSet.new }

      before (:each) do
        arg_sets.push(arg_set)
        arg_sets.push(arg_set_2)
        arg_set.stub(:times_called).and_return(2)
        arg_set_2.stub(:times_called).and_return(3)
      end

      it 'it should return whether the sum of its argset invocations is the same as the number of request made' do
        expect(sut.times?(5)).to be_true
        expect(sut.times?(3)).to be_false
      end
    end
  end
end
