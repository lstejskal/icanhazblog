class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  
  embedded_in :article, :inverse_of => :tags
  
  validates_presence_of :name
  validates_length_of :name, :minimum => 2, :maximum => 50
  validates_uniqueness_of :name
  
  def self.find_by_name(name)
    self.where(:name => name).first
  end

  # return all unique tags from articles
  # OPTIMIZE
  def self.all
    Article.only(:tags).all.map(&:tags).flatten.uniq
  end
  
end
