require 'spec_helper'

describe "LayoutLinks" do
  it "should have a home page at'/'" do
   get '/'
 response.should have_selector('title',:content =>"Home")
end

 it "should have contact page at'/contact '"do
 get '/contact'
response.should have_selector('title',:content =>'Contact')
 end

it "should have contact page at'/about '"do
 get '/about'
response.should have_selector('title',:content =>'About')
 end

it "should have contact page at'/help '"do
 get '/help'
response.should have_selector('title',:content =>'Help')
 end

it "should have  sign up page at'/signup'"do
get '/signup'
response.should have_selector('title',:content =>'sign up')
end


it "should have  sign in page at'/signin'"do
get '/signin'
response.should have_selector('title',:content =>'sign in')
end


it "should have the right links of the layouts"do
visit root_path
response.should have_selector('title',:content =>"Home")
click_link"about"
response.should have_selector('title',:content=>"About")
click_link "contact"
response.should have_selector('title',:content=>"Contact")
click_link "home"
response.should have_selector('title',:content=>"Home")
click_link "sign up now!"
response.should have_selector('title',:content=>"sign up")


end
#--------------------
 describe"when not signed in"do
  it"should have a sign in link"do
  visit root_path
  response.should have_selector("a" ,:href=>signin_path,
                                     :content=>"sign in")

 end
end
#--------------------------------
describe"when sigined in"do

  before(:each)do
  @user= Factory(:user)
  visit signin_path
  fill_in :email, :with =>@user.email
  fill_in :password,:with =>@user.password
  click_button
  end

  it "should have asignout link"do
   visit root_path
    response.should have_selector("a" ,:href=>signout_path,
                                     :content=>"sign out")

  end

  it"should have aprofile link"do
  visit root_path
   response.should have_selector("a" ,:href=>user_path(@user),
                                     :content=>"profile")


  end
end






#--------------------------------------

end






















