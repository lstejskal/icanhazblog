class User
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :email, :password, :nickname

  field :email
  field :password_hash
  field :password_salt
  field :nickname
  field :admin, :type => Boolean, :default => false
  field :last_login, :type => Time

  attr_accessor :password
  
  before_save :encrypt_password

  validates_presence_of :email, :nickname
  validates_presence_of :password, :on => :create  
  validates_uniqueness_of :email 
  validates_uniqueness_of :nickname
    
  def encrypt_password
    if password.present?  
      self.password_salt = BCrypt::Engine.generate_salt  
      self.password_hash = BCrypt::Engine.hash_secret(self.password, self.password_salt)  
    end      
  end
  
end
