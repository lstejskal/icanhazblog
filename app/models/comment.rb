class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title
  field :content
  field :user_nickname
  field :user_location

  embedded_in :article, :inverse_of => :comments
end
