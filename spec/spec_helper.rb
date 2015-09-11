Dir.chdir(File.join(File.dirname(__FILE__), '..,lib'.split(','))) do
  require 'fakes.rb'
end

def catch_exception(&_block)
  yield
rescue Exception => e
  e
end

module RSpec
  Matchers.define :contain do|string_to_find|
    match do|string_element|
      string_element.include?(string_to_find)
    end
  end
end

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = :should
  end
end
