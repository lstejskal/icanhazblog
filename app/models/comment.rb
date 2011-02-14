class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title
  field :content
  field :user_nickname, :default => "Anonymous"
  field :user_location

  embedded_in :article, :inverse_of => :comments

  validates_presence_of :title, :content
  validates_length_of :title, :maximum => 100
  validates_length_of :content, :maximum => 500
  validates_length_of :user_nickname, :maximum => 50
  validates_length_of :user_location, :maximum => 50

end
