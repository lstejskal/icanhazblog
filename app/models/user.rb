class User
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible [] # all attributes are protected

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
  
  def self.find_by_email(email)
    self.where(:email => email).first
  end
  
  # check whether user has valid password
  #
  def self.authenticate(email, password)  
    user = self.find_by_email(email)

    if user && (user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt))
      user
    else  
      nil  
    end  
  end  

end
