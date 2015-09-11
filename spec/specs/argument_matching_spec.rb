module Fakes
  describe ArgumentMatching do
    context 'when creating matchers' do
      it 'should be able to create a matcher that matches anything' do
        (1..10).each { |item| expect(ArgumentMatching.any.matches?(item)).to be_true }
      end
      it 'should be able to create a numeric greater than matcher' do
        match = ArgumentMatching.greater_than(5)
        expect(match.matches?(4)).to be_false
        expect(match.matches?(5)).to be_falsey
        expect(match.matches?(6)).to be_truthy
      end
      it 'should be able to create a range matcher' do
        match = ArgumentMatching.in_range((1..10))
        expect(match.matches?(4)).to be_true
        expect(match.matches?(10)).to be_truthy
        expect(match.matches?(11)).to be_falsey
      end
      it 'should be able to create a nil matcher' do
        match = ArgumentMatching.nil
        expect(match.matches?(nil)).to be_true
        expect(match.matches?(10)).to be_falsey
      end
      it 'should be able to create a not nil matcher' do
        match = ArgumentMatching.not_nil
        expect(match.matches?(10)).to be_true
        expect(match.matches?(nil)).to be_falsey
      end
      it 'should be able to create a regex string matcher' do
        match = ArgumentMatching.regex(/a|e|i|o|u/)
        expect(match.matches?('awwef')).to be_true
        expect(match.matches?('rwwgf')).to be_falsey
      end

      it 'should be able to create a lambda based matcher' do
        match = ArgumentMatching.condition { |item| item > 3 }
        expect(match.matches?(2)).to be_false
        expect(match.matches?(7)).to be_truthy
      end
    end
  end
end
