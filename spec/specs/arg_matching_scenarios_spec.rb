require 'spec_helper'

module Fakes
  describe "Arg matching scenarios" do
    it "should be able to intercept using argument matchers" do
      fake = Fake.new

      fake.hello("World")

      expect(fake.received(:hello).called_with(ArgumentMatching.any)).to_not be_nil
    end

    it "should be able to intercept using greater than matchers" do
      fake = Fake.new

      fake.hello(10)

      expect(fake.received(:hello).called_with(ArgumentMatching.greater_than(2))).to_not be_nil
    end

    it "should be able to intercept using regex matchers" do
      fake = Fake.new

      fake.hello("This is cool")

      expect(fake.received(:hello).called_with(ArgumentMatching.regex(/is/))).to_not be_nil
    end

    it "should be able to intercept using range matchers" do
      fake = Fake.new

      fake.hello(7)

      expect(fake.received(:hello).called_with(ArgumentMatching.in_range(4..8))).to_not be_nil
    end

    it "should be able to intercept using conditional matchers" do
      fake = Fake.new

      fake.hello(7)

      expect(fake.received(:hello).called_with(ArgumentMatching.condition{|item| item < 10})).to_not be_nil
    end

    it "should be able to intercept by mixing regular arguments with matchers" do
      fake = Fake.new

      fake.hello(7,4,"Yes")

      expect(fake.received(:hello).called_with(7,ArgumentMatching.greater_than(2),ArgumentMatching.regex(/Y/))).to_not be_nil
      expect(fake.received(:hello).called_with(7,ArgumentMatching.any,ArgumentMatching.regex(/Y/))).to_not be_nil
      expect(fake.received(:hello).called_with(7,ArgumentMatching.any,"Yes")).to_not be_nil
      expect(fake.received(:hello).called_with(6,ArgumentMatching.any,"Yes")).to be_nil
    end
  end

end
