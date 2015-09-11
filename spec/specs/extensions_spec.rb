require 'spec_helper'

describe Fakes do
  it 'should be able to create a new fake' do
    expect(fake.class).to eql(Fakes::Fake)
  end
  it 'should be able to create a new fake and specify return values for methods' do
    item = fake hello: 'World', age: 33
    expect(item.hello).to eql('World')
    expect(item.age).to eql(33)
  end

  context 'when specifying a fake for a class' do
    let(:swaps) { fake }
    before(:each) do
      Fakes::ClassSwaps.stub(:instance).and_return(swaps)
    end
    before(:each) do
      @result = fake_class Dir
    end

    it 'should register a new fake with the class swaps' do
      expect(swaps.received(:add_fake_for).called_with(Dir, arg_match.not_nil)).to_not be_nil
    end

    it 'should return the newly created fake' do
      expect(@result).to_not be_nil
    end
  end
  context 'when faking a class and specifying return values' do
    before(:each) do
      fake_class Dir, exist?: true
    end
    after(:each) do
      reset_fake_classes
    end
    it 'should replace the class with the fake return to return the values specified' do
      expect(Dir.exist?('hello')).to be true
    end
  end

  context 'resetting fake classes' do
    let(:swaps) { fake }
    before(:each) do
      Fakes::ClassSwaps.stub(:instance).and_return(swaps)
    end
    before(:each) do
      reset_fake_classes
    end
    it 'should be able to reset all of the fake classes' do
      swaps.received(:reset)
    end
  end
end
