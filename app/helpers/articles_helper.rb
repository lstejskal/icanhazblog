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
  
  # wrapper for articles' content formatting 
  #
  def formatted_text(text)
    raw(coderay(text))
  end
  
  # generate syntax highlighting for <code lang="ruby">...</code> segments
  #
  def coderay(text = "")
    text.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do  
      CodeRay.scan($3, $2).div(:css => :class, :line_numbers => :table)  
    end
  end
  
end
