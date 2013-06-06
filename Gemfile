source 'http://rubygems.org'

gem 'rake', '~> 10.0.4'

gem 'rails', '3.2.13'

# TODO try "rainbows" web server
# gem 'rainbows'

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

# exception reporting
gem 'exception_notification', '~> 2.4', :require => 'exception_notifier'

# Gems used only for assets and not required in production by default
group :assets do  
  gem 'sass-rails', "~> 3.2.6"  
  gem 'coffee-rails', "~> 3.2.2"  
  gem 'uglifier'  
end  
  
gem 'jquery-rails'  

# debugging is allowed by default
# in development environment
group :development do
  gem 'ruby-debug19' 
end

# some test utilities can be used even in rails console
# during development
group :development, :test do
  gem 'minitest'
  gem 'shoulda'
  gem 'turn' # , '< 0.8.3'
  gem 'factory_girl'
  gem 'fakeweb'
  gem 'mocha', require: 'mocha/setup'
end
