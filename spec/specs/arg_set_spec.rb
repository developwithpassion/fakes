require 'spec_helper'

module Fakes
  describe ArgSet do
    context "when created" do
      let(:sut){ArgSet.new([1])}

      
      it "should initialize required members" do
        expect(sut.times_called).to eql(0)
      end

    end

  end
end
