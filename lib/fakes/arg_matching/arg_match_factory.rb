module Fakes
  class ArgMatchFactory
    def self.create_arg_matcher_using(args)
      combined_matcher = CombinedArgMatcher.new      
      args.each do|arg|
        matcher = arg.respond_to?(:matches?) ? arg : RegularArgMatcher.new(arg)
        combined_matcher << matcher
      end
      combined_matcher
    end
  end
end
