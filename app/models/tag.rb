class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  
  embedded_in :article, :inverse_of => :tags
  
  validates_presence_of :name
  validates_length_of :name, :minimum => 2, :maximum => 50
end
