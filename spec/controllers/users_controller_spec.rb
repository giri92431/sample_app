require 'spec_helper'

describe UsersController do
render_views

describe" GET 'show'"do

before(:each)do
 @user=Factory(:user)
end

it "should be sucesses"do
  get :show, :id=>@user
  response.should be_success
end

it"should find the rit user"do
get :show, :id=>@user
assigns(:user).should == @user
end

it "should havethe right title"do
 get:show,:id=>@user
 response.should have_selector('title',:content=>@user.name)
end

it"should have the right selector "do
get:show, :id=>@user
response.should have_selector('h1',:content=>@user.name)
end

it "should have a profile image"do
get:show ,:id=>@user
response.should have_selector('h1>img',:class=>"gravatar")
end
it "should have a right url"do
get:show,:id=>@user
response.should have_selector('td>a',:content =>user_path(@user),
                                      :href =>user_path(@user))
end
end
#---------------------------------------
  describe "GET 'new'" do
    it "returns http success" do
      get :new
      response.should be_success
    end

   it "should have the rit title "do
   get :new
  response.should have_selector('title',:content =>"sign up")
   end

end

end
#-----------------------------------------
