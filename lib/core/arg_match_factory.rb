module Fakes
  class ArgMatchFactory
    def self.create_arg_matcher_using(args)
      matcher = CombinedArgMatcher.new      
      args.each do|arg|
        current_matcher = arg.respond_to?(:is_used_in_the_arg_matching_process) ? arg : RegularArgMatcher.new(arg)
        matcher.add current_matcher
      end
      matcher
    end
  end
end
