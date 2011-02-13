class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email
  field :password_hash
  field :password_salt
  field :nickname
  field :admin, :type => Boolean
  field :last_login, :type => Time
end
