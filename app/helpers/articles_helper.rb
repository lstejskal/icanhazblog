module ArticlesHelper
  
  def link_to_tag(tag_name)
    link_to tag_name, articles_path( Article.sanitize_search_params( params.merge(:tag => tag_name) ) )
  end
  
  def list_of_tags(tags = [])
    tags.map { |tag| link_to_tag(tag) }.join(" ")
  end
  
  def user_info(comment)
    if comment.user_nickname.present?
      comment.user_nickname + (comment.user_location ? " (%s)" % comment.user_location : "") + ": "
    else
      ""
    end
  end
  
end
