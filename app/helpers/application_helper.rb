module ApplicationHelper
  
  # create link to article search
  #
  def search_link_to(name, search_params)
    link_to name, articles_path( Article.sanitize_search_params( params.merge(search_params) ) )
  end
  
  # display date
  # format: day_of_the_week, month_name day_nr, year
  # example: Thursday, March 03, 2011 
  #
  def formatted_date(date)
    date.strftime("%A, %B %m, %Y")
  end
end
