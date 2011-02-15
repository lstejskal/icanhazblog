
# load factories
# PS: for test environment factories are loaded from test/test_helper
if Rails.env.development?
  Dir[ File.join(File.dirname(__FILE__), '../../test/factories/*.rb') ].each { |f| require f }
end
