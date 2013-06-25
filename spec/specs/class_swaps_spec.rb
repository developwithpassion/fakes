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
      attr_accessor :inititated,:was_reset

      def initiate
        @inititated = true
      end
      def reset
        @was_reset = true
      end
    end
    context 'when a class swap is registered ' do
      context  'and it does not already exist' do
        let(:the_sym){MyClass.to_s.to_sym}
        let(:replacement){Object.new}
        let(:the_swap){MySwap.new}
        let(:sut){ClassSwaps.instance}
        before (:each) do
          ClassSwap.stub(:new).with(MyClass,replacement).and_return(the_swap)
        end
        after (:each) do
          sut.swaps.clear
        end

        before (:each) do
          sut.add_fake_for(MyClass,replacement)
        end

        it 'should add a new class swap to the set of class swaps' do
          ClassSwaps.instance.swaps[the_sym].should == the_swap
        end

        it "should initiate the swap" do
          the_swap.inititated.should be_true
        end
        

      end
      context  'and it already exist' do
        let(:the_sym){MyClass.to_s.to_sym}
        let(:sut){ClassSwaps.instance}
        before (:each) do
          sut.swaps[the_sym] = 2
        end
        after (:each) do
          sut.swaps.clear
        end

        before (:each) do
          @exception = catch_exception {sut.add_fake_for(MyClass,Object.new)}
        end

        it 'should throw an error indicating that the swap is already present' do
          @exception.message.should contain(MyClass.to_s)
        end
      end
    end
    context  'when reset' do
      let(:first_swap){MySwap.new}
      let(:second_swap){MySwap.new}
      let(:sut){ClassSwaps.instance}

      before (:each) do
        sut.swaps[:first] = first_swap
        sut.swaps[:second] = second_swap
      end

      before (:each) do
        sut.reset
      end

      it 'should reset each of the swaps' do
        first_swap.was_reset.should be_true
        second_swap.was_reset.should be_true
      end
      it "should clear the swaps" do
        sut.swaps.count.should == 0
      end
    end
    context "Integration Test" do
      let(:replacement){ Object.new }
      
      it 'should be able to swap class values' do
        ClassSwaps.instance.add_fake_for(Dir,replacement)
        Dir.should == replacement
        ClassSwaps.instance.reset
        Dir.should_not == replacement
      end

      it 'should be able to swap class values in another module' do
        ClassSwaps.instance.add_fake_for(SomeModule::ClassInAModule,replacement)
        SomeModule::ClassInAModule.should == replacement
        ClassSwaps.instance.reset
        SomeModule::ClassInAModule.should_not == replacement

        ClassSwaps.instance.add_fake_for(SomeModule::NestedModule::AClassInANestedModule,replacement)
        SomeModule::NestedModule::AClassInANestedModule.should == replacement
        ClassSwaps.instance.reset
        SomeModule::NestedModule::AClassInANestedModule.should_not == replacement
      end
    end
  end
end
