
Factory.define :article, :class => Article do |document|
  document.sequence(:title)       { |n| "Article #{n}" }
  document.content                { |d| "This is a content for #{d.title}." }
  document.visible                false
  document.published_at           nil
  
  document.comments               []
  document.tags                   %w{ ruby rails sinatra }
end

Factory.define :published_article, :class => Article do |document|
  document.sequence(:title)       { |n| "Article #{n}" }
  document.content                { |d| "This is a content for #{d.title}." }
  document.visible                true
  document.published_at           Time.now
  
  document.comments               []
  document.tags                   %w{ ruby rails sinatra }
end

