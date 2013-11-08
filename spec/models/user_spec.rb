require 'spec_helper'

describe User do

before(:each)do
@attr = {:name=>"example users",:email=>"user@example.com"}
end

  it "should create a new instance" do
 User.create!(@attr)
end

it "should require a name" do
no_name_user = User.new(@attr.merge(:name=>""))
no_name_user.should_not be_valid
end

it"should reqire a valid email " do
no_email_user=User.new(@attr.merge(:email=>""))
no_email_user.should_not be_valid
end

it "should reject name that are too long"do
long_name= "a" * 51
long_name_user =User.new(@attr.merge(:name => long_name))
long_name_user.should_not be_valid
end

it"should expect valid emaild" do
addresses=%w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
addresses.each do|address|
valid_email_user=User.new(@attr.merge(:email=>address))
valid_email_user.should be_valid 
end
end

it"should reject invalid email id"do
addresses=%w[user@foo,com THE_USER_foo.org first.last@foo.]
addresses.each do|address|
invalid_email_user=User.new(@attr.merge(:email=>address))
invalid_email_user.should_not be_valid
end
end
it "should reject dublicate emailid" do
User.create!(@attr)
user_with_dublicate_email=User.new(@attr)
user_with_dublicate_email.should_not be_valid
end

it"should reject email id upto case"do
upcased_email=@attr[:email].upcase
User.create!(@attr.merge(:email=>upcased_email))
user_with_dublicate_email=User.new(@attr)
user_with_dublicate_email.should_not be_valid
end
end









