Dir.chdir(File.join(File.dirname(__FILE__),"..,lib".split(','))) do
  require 'fakes.rb'
end

def catch_exception(&block)
  begin
    yield
  rescue Exception => e
    e
  end
end

module RSpec
  Matchers.define :contain do|string_to_find|
    match do|string_element|
        string_element.include?(string_to_find)
    end
  end
end
