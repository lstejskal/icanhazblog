module ApplicationHelper
  
  # create standardized, seo-friendly link to article: yyyy/mm/article-alias
  # TODO could this be done completely in routes config?
  #
  def link_to_article(article, options = {})
    link_to (options[:title] || article.title),
      yyyy_mm_article_path(article.alias,
        :year => article.year, :month => article.month)
  end
  
  # create link to article search
  #
  def search_link_to(name, search_params, link_params = {})
    link_to name, articles_path( Article.sanitize_search_params(search_params) ), link_params
  end
  
  # display date
  # format: day_of_the_week, month_name day_nr, year
  # example: Thursday, March 03, 2011 
  #
  def formatted_date(date)
    date.present? ? date.strftime("%A, %B %d, %Y") : ""
  end
end
