
Factory.define :comment, :class => Comment do |document|
  document.sequence(:title)     { |n| "comment_#{n}" }
  document.content              { |d| "This is a content for #{d.title}." }
  document.user_nickname        { |d| "user_#{d.title}" }
  document.user_location        { |d| %w{ Prague Paris London }.sample }  
end
