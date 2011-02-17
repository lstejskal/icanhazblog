# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

# create admin account
User.create(
  :email => 'lstejskal@email.com',
  :password => 'letsblog!',
  :nickname => 'lstejskal',
  :admin => true
)

# create basic tags
%w{ ruby rails sinatra padrino python }.each { |tag_name| Tag.create(:name => tag_name) }
