source 'http://rubygems.org'

gem 'rails', '3.0.9'

# specify web server
# gem 'unicorn'

# mongodb
gem 'mongo', '1.3.1'
gem 'bson_ext', '1.3.1'
# TODO update to 2.0.x
gem 'mongoid', '= 2.0.0.rc.6'

# password encryption
gem 'bcrypt-ruby', :require => 'bcrypt' 

# template handler
gem 'haml'

# css extension
gem 'sass'

# syntax highlighting
gem 'coderay'

# captcha in comment forms
gem 'recaptcha', :require => 'recaptcha/rails'

# debugging is allowed by default
# in development environment
group :development do
  gem 'ruby-debug19' 
end

# some test utilities can be used even in rails console
# during development
group :development, :test do
  gem 'shoulda'
  gem 'turn'
  gem 'factory_girl'
  gem 'fakeweb'
  gem 'mocha'
end

