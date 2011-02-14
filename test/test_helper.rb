ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# load factories
# PS: comment and tag factories have to be loaded before article factory
%w{ user comment tag article }.each do |filename|
  require File.join(File.dirname(__FILE__), 'factories', "#{filename}_factory")
end

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
