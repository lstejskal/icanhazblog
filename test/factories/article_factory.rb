
Factory.define :article, :class => Article do |document|
  document.sequence(:title)       { |n| "Article #{n}" }
  document.content                { |d| "This is a content for #{d.title}." }
  document.visible                true
  document.published_at           Time.parse("12.02.2011")
  
  document.comments               []
  document.tags                   %w{ ruby rails sinatra }
end

Factory.define :unpublished_article, :class => Article do |document|
  document.sequence(:title)       { |n| "Article #{n}" }
  document.content                { |d| "This is a content for #{d.title}." }
  
  document.comments               []
  document.tags                   []
end

Factory.define :article_ruby, :class => Article do |document|
  document.title                  "I like ruby"
  document.content                { |d| "This is a content for #{d.title}." }
  document.visible                true
  document.published_at           Time.parse("05.02.2011")
  
  document.comments               []
  document.tags                   %w{ ruby }
end

Factory.define :article_rails, :class => Article do |document|
  document.title                  "I like ruby on rails"
  document.content                { |d| "This is a content for #{d.title}." }
  document.visible                true
  document.published_at           Time.parse("10.02.2011")
  
  document.comments               []
  document.tags                   %w{ ruby rails }
end

Factory.define :article_sinatra, :class => Article do |document|
  document.title                  "I like sinatra"
  document.content                { |d| "This is a content for #{d.title}." }
  document.visible                true
  document.published_at           Time.parse("12.02.2011")
  
  document.comments               []
  document.tags                   %w{ sinatra }
end
