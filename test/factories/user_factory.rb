
Factory.define :user, :class => User do |document|
  document.sequence(:nickname)   { |n| "user_#{n}" }
  document.email                 { |d| "#{d.nickname}@blogger.com" }
  document.password              { |d| "#{d.nickname}_password" }
  document.admin                 false
end

Factory.define :admin_user, :class => User do |document|
  document.nickname             "lstejskal"
  document.email                "lukas.stejskal@myemaildomain.com"
  document.password             "letsdosomeblogging!"
  document.admin                true
end
