
Factory.define :tag, :class => Tag do |document|
  document.sequence(:name)     { |n| "tag_#{n}" }
end
