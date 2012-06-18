require 'spec_helper'

module Fakes
  class MyClass
  end
  describe ClassSwap do
    context "when created" do
      let(:sut){ClassSwap.new(MyClass,Object.new)}

      it "should store the symbol of the class it is going to replace" do
        sut.klass.should == :MyClass
      end
    end
    context "when initiated" do
      let(:replacement){Object.new}
      let(:the_sym){:MyClass}
      let(:remove_strategy){Proc.new do|klass_to_remove|
        @klass_to_remove = klass_to_remove
        MyClass
      end}
      let(:set_strategy){Proc.new do|klass_to_change,new_value|
        @klass_to_change = klass_to_change
        @replacement_value = new_value
        MyClass
      end}
      let(:sut){ClassSwap.new(MyClass,replacement,:remove_strategy => remove_strategy,:set_strategy => set_strategy)}

      before (:each) do
        sut.initiate
      end
      
      it "should remove the current value of the class constant and store it for reset at a later point" do
        @klass_to_remove.should == the_sym
      end
      it "should replace the current value of the symbol with the replacement value" do
        @klass_to_change.should == the_sym
        @replacement_value.should == replacement
      end
    end
    context "when reset" do
      let(:original){MyClass}
      let(:the_sym){:MyClass}
      let(:replacement){Object.new}
      let(:remove_strategy){Proc.new do|klass_to_remove|
        @klass_to_remove = klass_to_remove
        MyClass
      end}
      let(:set_strategy){Proc.new do|klass_to_change,new_value|
        @klass_to_change = klass_to_change
        @replacement_value = new_value
        MyClass
      end}
      let(:sut){ClassSwap.new(MyClass,replacement,:remove_strategy => remove_strategy,:set_strategy => set_strategy)}

      before (:each) do
        sut.original = MyClass
      end
      
      


      before (:each) do
        sut.reset
      end
      
      it "should switch the value of the class back to its original value" do
        @klass_to_remove.should == the_sym
        @klass_to_change.should == the_sym
        @replacement_value.should == MyClass
      end
    end
  end
end
