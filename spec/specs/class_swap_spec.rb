require 'spec_helper'

module Fakes
  class MyClass
  end
  describe ClassSwap do
    context 'when created' do
      let(:sut) { ClassSwap.new(MyClass, Object.new) }

      it 'should store the symbol of the class it is going to replace' do
        expect(sut.klass).to eql(:MyClass)
      end
    end
    context 'when initiated' do
      let(:replacement) { Object.new }
      let(:the_sym) { :MyClass }
      let(:remove_strategy) do
        proc do|klass_to_remove|
        @klass_to_remove = klass_to_remove
        MyClass
      end
      end
      let(:set_strategy) do
        proc do|klass_to_change, new_value|
        @klass_to_change = klass_to_change
        @replacement_value = new_value
        MyClass
      end
      end
      let(:sut) { ClassSwap.new(MyClass, replacement, remove_strategy: remove_strategy, set_strategy: set_strategy) }

      before (:each) do
        sut.initiate
      end

      it 'should remove the current value of the class constant and store it for reset at a later point' do
        expect(@klass_to_remove).to eql(the_sym)
      end
      it 'should replace the current value of the symbol with the replacement value' do
        expect(@klass_to_change).to eql(the_sym)
        expect(@replacement_value).to eql(replacement)
      end
    end
    context 'when reset' do
      let(:original) { MyClass }
      let(:the_sym) { :MyClass }
      let(:replacement) { Object.new }
      let(:remove_strategy) do
        proc do|klass_to_remove|
        @klass_to_remove = klass_to_remove
        MyClass
      end
      end
      let(:set_strategy) do
        proc do|klass_to_change, new_value|
        @klass_to_change = klass_to_change
        @replacement_value = new_value
        MyClass
      end
      end
      let(:sut) { ClassSwap.new(MyClass, replacement, remove_strategy: remove_strategy, set_strategy: set_strategy) }

      before (:each) do
        sut.original = MyClass
      end

      before (:each) do
        sut.reset
      end

      it 'should switch the value of the class back to its original value' do
        expect(@klass_to_remove).to eql(the_sym)
        expect(@klass_to_change).to eql(the_sym)
        expect(@replacement_value).to eql(MyClass)
      end
    end
  end
end
