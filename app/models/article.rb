
class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title
  # TODO will string data type be enough? check out mongodb documentation
  field :content, :type => String
  field :visible, :type => Boolean, :default => false
  field :published_at, :type => DateTime
  
  embeds_many :comments
  # TODO implement as relational reference?
  field :tags, :type => Array
  
  validates_presence_of :title, :content
  validates_uniqueness_of :title
  validates_length_of :title, :minimum => 3, :maximum => 250
  
  # provide public interface for listing and searching articles
  #
  def self.list(params = {})    
    params = self.sanitize_search_params(params)
    
    params[:page] ||= 1
    params[:per_page] ||= 10
    
    q = self
    
    # show only visible articles
    q = q.where(:visible => true)
    
    # set order
    q = q.descending(:published_at)
    
    q.paginate(params)
  end
  
  protected
  
  ALLOWED_SEARCH_KEYS = %w{ page per_page } 
  
  # keep only allowed parameters and symbolize them
  #
  def self.sanitize_search_params(params = {})
    Hash[ params.to_a.map do |k,v|
      ALLOWED_SEARCH_KEYS.include?(k.to_s) ? [ k.to_sym, v ] : nil
    end.compact ]
  end
  
end
