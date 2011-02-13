class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title
  # TODO will string data type be enough? check out mongodb documentation
  field :content, :type => String
  field :visible, :type => Boolean
  field :published_at, :type => Time
  
  embeds_many :comments
  embeds_many :tags
end
