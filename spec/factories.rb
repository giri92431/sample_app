Factory.define :user do |user|
 user.name                   "michael hartl"
 user.email                  "michak@example.com"
 user.password               "foobar"
 user.password_confirmation  "foobar"
end


 Factory.sequence :email do|n|
  "person-#{n}@example.com"
 end




Factory.define :micropost do|micropost|
 micropost.content "foobar"
 micropost.association :user
end
