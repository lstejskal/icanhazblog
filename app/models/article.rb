class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title
  # TODO will string data type be enough? check out mongodb documentation
  field :content, :type => String
  field :visible, :type => Boolean, :default => false
  field :published_at, :type => DateTime
  
  embeds_many :comments
  embeds_many :tags
  
  validates_presence_of :title, :content
  validates_uniqueness_of :title
  validates_length_of :title, :minimum => 3, :maximum => 250
  
end
