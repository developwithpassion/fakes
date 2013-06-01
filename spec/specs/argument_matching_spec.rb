module Fakes
  describe ArgumentMatching do
    context "when creating matchers" do
      it "should be able to create a matcher that matches anything" do
        (1..10).each{|item| ArgumentMatching.any.matches?(item).should be_true}
      end
      it "should be able to create a numeric greater than matcher" do
        match = ArgumentMatching.greater_than(5)
        match.matches?(4).should be_false
        match.matches?(5).should be_false
        match.matches?(6).should be_true
        
      end
      it "should be able to create a range matcher" do
        match = ArgumentMatching.in_range((1..10))
        match.matches?(4).should be_true
        match.matches?(10).should be_true
        match.matches?(11).should be_false
      end
      it "should be able to create a nil matcher" do
        match = ArgumentMatching.nil
        match.matches?(nil).should be_true
        match.matches?(10).should be_false
      end
      it "should be able to create a not nil matcher" do
        match = ArgumentMatching.not_nil
        match.matches?(10).should be_true
        match.matches?(nil).should be_false
      end
      it "should be able to create a regex string matcher" do
        match = ArgumentMatching.regex(/a|e|i|o|u/)
        match.matches?("awwef").should be_true
        match.matches?("rwwgf").should be_false
      end

      it "should be able to create a lambda based matcher" do
        match = ArgumentMatching.condition{|item| item > 3}
        match.matches?(2).should be_false
        match.matches?(7).should be_true
      end
    end
    
    
  end
  
end