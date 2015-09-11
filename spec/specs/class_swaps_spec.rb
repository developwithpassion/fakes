require 'spec_helper'

module SomeModule
  module NestedModule
    class AClassInANestedModule
    end
  end
  class ClassInAModule
  end
end
module Fakes
  class SomeClass
    def self.calculate
      42
    end
  end
  describe ClassSwaps do
    class MySwap
      attr_accessor :inititated, :was_reset

      def initiate
        @inititated = true
      end

      def reset
        @was_reset = true
      end
    end
    context 'when a class swap is registered ' do
      context 'and it does not already exist' do
        let(:the_sym) { MyClass.to_s.to_sym }
        let(:replacement) { Object.new }
        let(:the_swap) { MySwap.new }
        let(:sut) { ClassSwaps.instance }
        before(:each) do
          ClassSwap.stub(:new).with(MyClass, replacement).and_return(the_swap)
        end
        after(:each) do
          sut.swaps.clear
        end

        before(:each) do
          sut.add_fake_for(MyClass, replacement)
        end

        it 'should add a new class swap to the set of class swaps' do
          expect(ClassSwaps.instance.swaps[the_sym]).to eql(the_swap)
        end

        it 'should initiate the swap' do
          expect(the_swap.inititated).to be true
        end
      end
      context 'and it already exist' do
        let(:the_sym) { MyClass.to_s.to_sym }
        let(:sut) { ClassSwaps.instance }
        before(:each) do
          sut.swaps[the_sym] = 2
        end
        after(:each) do
          sut.swaps.clear
        end

        before(:each) do
          @exception = catch_exception { sut.add_fake_for(MyClass, Object.new) }
        end

        it 'should throw an error indicating that the swap is already present' do
          expect(@exception.message).to contain(MyClass.to_s)
        end
      end
    end
    context 'when reset' do
      let(:first_swap) { MySwap.new }
      let(:second_swap) { MySwap.new }
      let(:sut) { ClassSwaps.instance }

      before(:each) do
        sut.swaps[:first] = first_swap
        sut.swaps[:second] = second_swap
      end

      before(:each) do
        sut.reset
      end

      it 'should reset each of the swaps' do
        expect(first_swap.was_reset).to be true
        expect(second_swap.was_reset).to be_truthy
      end
      it 'should clear the swaps' do
        expect(sut.swaps.count).to eql(0)
      end
    end
    context 'Integration Test' do
      let(:replacement) { Object.new }

      it 'should be able to swap class values' do
        ClassSwaps.instance.add_fake_for(Dir, replacement)
        expect(Dir).to eql(replacement)
        ClassSwaps.instance.reset
        expect(Dir).to_not eql(replacement)
      end

      it 'should be able to swap class values in another module' do
        ClassSwaps.instance.add_fake_for(SomeModule::ClassInAModule, replacement)
        expect(SomeModule::ClassInAModule).to eql(replacement)
        ClassSwaps.instance.reset
        expect(SomeModule::ClassInAModule).to_not eql(replacement)

        ClassSwaps.instance.add_fake_for(SomeModule::NestedModule::AClassInANestedModule, replacement)
        expect(SomeModule::NestedModule::AClassInANestedModule).to eql(replacement)
        ClassSwaps.instance.reset
        expect(SomeModule::NestedModule::AClassInANestedModule).to_not eql(replacement)
      end
    end
  end
end
