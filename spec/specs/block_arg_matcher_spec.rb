require 'spec_helper'

module Fakes
  describe BlockArgMatcher do
    context 'when determining if it matches a value' do
      let(:sut) { BlockArgMatcher.new(->(item) { true }) }

      it 'should decide by using its provided block' do
        expect(sut.matches?(2)).to be true
      end
    end
  end
end
