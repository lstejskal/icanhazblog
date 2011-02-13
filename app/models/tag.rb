class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  
  embedded_in :article, :inverse_of => :tags
end
