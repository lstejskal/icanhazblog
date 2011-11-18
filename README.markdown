# I Can Haz Blog?! #

## Description ##

Icanhazblog is a blog application running on MongoDB and Rails 3.

## Installation ##

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

* Set up your tracking code
`public/javascripts/tracking_code.js.example -> tracking_code.js`

* Set up production environment
`config/environments/production.rb.example -> production.rb`

* Run +rails server+ and go to +http://localhost:3000/+

## TODO ##

* use (optionally) Markdown notation to write blog posts instead of HTML

* make blog easier configurable - move blog title and similar "constants" to
  configuration or localizations

* create rake task for setting up blog (instead describing these tasks in README)

## Author ##

2010-2011 Lukas Stejskal
