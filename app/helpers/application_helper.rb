module ApplicationHelper
  
  # create link to article search
  #
  def search_link_to(name, search_params)
    link_to name, articles_path( Article.sanitize_search_params( params.merge(search_params) ) )
  end
  
end
