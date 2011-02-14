
Factory.define :article, :class => Article do |document|
  document.sequence(:title)       { |n| "Article #{n}" }
  document.content                { |d| "This is a content for #{d.title}." }
  document.visible                false
  document.published_at           nil

  document.comments               5.times.map { Factory.create(:comment) } 
  document.tags                   3.times.map { Factory.create(:tag) } 
end

