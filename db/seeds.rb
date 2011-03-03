# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

# create admin account (attributes are protected against mass assignment)
u = User.new
u.email = 'admin@email.com'
u.password = 'letsblog!'
u.nickname = 'admin'
u.admin = true
u.save!


