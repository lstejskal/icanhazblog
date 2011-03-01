# this model is not used at the moment
# TODO either remove Tag model or refactor it into relation to Article model
#
class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
    
  validates_presence_of :name
  validates_length_of :name, :minimum => 2, :maximum => 50
  validates_uniqueness_of :name
  
  def self.find_by_name(name)
    self.where(:name => name).first
  end

  # return all tags and their occurence from articles
  # ordered from the highest occurence to lowest
  #
  # OPTIMIZE
  #
  def self.all
    all_tags = Article.only(:tags).all.map(&:tags).flatten
    all_tags.inject(Hash.new(0)) { |h,v| h[v] += 1; h }.sort_by { |k,v| -v }
  end
  
end
