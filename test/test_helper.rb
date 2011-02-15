ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# load factories
Dir[ File.join(File.dirname(__FILE__), 'factories/*.rb') ].each { |f| require f }

class ActiveSupport::TestCase  
  def setup
    Mongoid.master.collections.select do |collection|
      (collection.name !~ /system/)
    end.each(&:drop) 
  end
  
  def teardown
  end
  
  CHARS = ('a'..'z').to_a

  def random_string(string_length = 100)
    string_length.times.collect { CHARS.sample }.join
  end
end
