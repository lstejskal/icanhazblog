source 'http://rubygems.org'

gem 'rails', '3.0.9'

# specify web server
# gem 'unicorn'

# mongodb
gem 'mongo', '~> 1.3'
gem 'bson_ext', '~> 1.3'
gem 'mongoid', '~> 2.1'

# password encryption
gem 'bcrypt-ruby', :require => 'bcrypt' 

# pagination for mongoid
# PS: 3.0 doesn't work with mongodb yet
gem 'will_paginate', '~> 2.3'

# template handler
gem 'haml', '~> 3.1'

# css extension
gem 'sass', '~> 3.1'

# syntax highlighting
gem 'coderay', '~> 0.9'

# captcha in comment forms
gem 'recaptcha', '~> 0.3', :require => 'recaptcha/rails'

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
