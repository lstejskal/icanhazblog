module ArticlesHelper
  
  def list_of_tags(tags = [])
    tags.map { |tag_name| search_link_to(tag_name, :tag => tag_name) }.join(" ")
  end
  
  def user_info(comment)
    if comment.user_nickname.present?
      comment.user_nickname + (comment.user_location ? " (%s)" % comment.user_location : "") + ": "
    else
      ""
    end
  end
  
end
