# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

# create admin account
User.create(
  :email => 'admin@email.com',
  :password => 'letsblog!',
  :nickname => 'admin',
  :admin => true
)

