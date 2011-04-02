module ArticlesHelper

  # display list of tags below article
  #  
  def list_of_tags(tags = [])
    return "none" if tags.empty?
    tags.map { |tag_name| search_link_to(tag_name, :tag => tag_name) }.join(", ")
  end

  # display list of all tags with their occurence in blog articles
  # 
  def tag_cloud
    Tag.all.map do |tag_name, tag_occurence|
      search_link_to("#{tag_name} (#{tag_occurence})", { :tag => tag_name }, { :class => "nobr" })
    end.join(", ")
  end
  
  # print information about user above comments
  #
  def user_info(comment)
    if comment.user_nickname.present?
      comment.user_nickname + (comment.user_location ? " (%s)" % comment.user_location : "")
    else
      "anonymous"
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
    text.gsub(/\<code( lang="(.+?)")?\>\s*(.+?)\<\/code\>/m) do  
      CodeRay.scan($3, $2).div( :css => :class,
        :line_numbers => :inline,
        :tab_width => 2
      )  
    end
  end
  
end
