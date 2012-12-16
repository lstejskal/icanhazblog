# I Can Haz Blog?!

## Project Status

*This software is now considered obsolete and no longer actively maintained.*

I decided to move from MongoDB to Mysql and it is such an essential switch
that instead of creating feature branch, I have created a whole new repository:
 [lstejskal/icanhazblog2](https://github.com/lstejskal/icanhazblog2).

## Description

Icanhazblog is a blog application running on MongoDB and Rails 3.

## Installation

* Install required gems:
`bundle install`

* Make sure your MongoDB database is running and set up Mongoid
`config/mongoid.yml.example -> mongoid.yml`

* Check if everything it working:
`rake test`

* Put initial data into database:
`rake db:setup`

* If you want to see some dummy blog posts in the application for the start, run:
`rake db:generate_random_articles`

* Set up API keys for [reCAPTCHA](https://github.com/ambethia/recaptcha)
`config/initializers/recaptcha.rb.example -> recaptcha.rb`

* Set up your secret token:
`config/initializers/secret_token.rb.example -> secret_token.rb`

* (Optional) set up your tracking code for Google Analytics, etc.
`app/assets/javascripts/tracking_code.js.example -> tracking_code.js`

* Set up production environment
`config/environments/production.rb.example -> production.rb`

* Run +rails server+ and go to +http://localhost:3000/+

## Author

2010-2012 Lukas Stejskal
