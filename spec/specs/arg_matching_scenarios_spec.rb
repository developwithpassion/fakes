require 'spec_helper'

module Fakes
  describe "Arg matching scenarios" do
    it "should be able to intercept using argument matchers" do
      fake = Fake.new

      fake.hello("World")

      fake.received(:hello).called_with(Matches.any).should_not be_nil
    end

    it "should be able to intercept using greater than matchers" do
      fake = Fake.new

      fake.hello(10)

      fake.received(:hello).called_with(Matches.greater_than(2)).should_not be_nil
    end

    it "should be able to intercept using regex matchers" do
      fake = Fake.new

      fake.hello("This is cool")

      fake.received(:hello).called_with(Matches.regex(/is/)).should_not be_nil
    end

    it "should be able to intercept using range matchers" do
      fake = Fake.new

      fake.hello(7)

      fake.received(:hello).called_with(Matches.in_range(4..8)).should_not be_nil
    end

    it "should be able to intercept using conditional matchers" do
      fake = Fake.new

      fake.hello(7)

      fake.received(:hello).called_with(Matches.condition(lambda{|item| item < 10})).should_not be_nil
    end

    it "should be able to intercept by mixing regular arguments with matchers" do
      fake = Fake.new

      fake.hello(7,4,"Yes")

      fake.received(:hello).called_with(7,Matches.greater_than(2),Matches.regex(/Y/)).should_not be_nil
      fake.received(:hello).called_with(7,Matches.any,Matches.regex(/Y/)).should_not be_nil
      fake.received(:hello).called_with(7,Matches.any,"Yes").should_not be_nil
      fake.received(:hello).called_with(6,Matches.any,"Yes").should be_nil
    end
  end

end
