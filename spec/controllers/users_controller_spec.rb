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



#-----------------------------------------
describe"Post ''create'"do
 
 describe"failure"do
   before(:each)do
   @attr={:name=>"",:email=>"",:password=>"",:password_confirmation=>""}
   end
   
   it"should have the rit tile"do
    post:create,:user=>@attr
    response.should have_selector('title',:content=>"sign up")
    end
   

    it"should renderthe new page"do
    post:create,:user=>@attr
    response.should render_template('new')
    end
    
    it "should creaate a user"do
    lambda do
     post :create,:user=>@attr
     end.should_not change(User,:count)
   end 
 end
 #----------------------------- 
  describe"success"do
   
    before(:each)do
    @attr={:name=>"new user",:email=>"user@example.com",:password=>"foobar",
                             :password_confirmation=>"foobar"}
    end
    
    it"should create a user"do 
    lambda do
    post :create, :user=>@attr
    end.should change(User,:count).by(1)
   end

   it"should redirect to the show page"do
   post :create, :user=>@attr
   response.should redirect_to(user_path(assigns(:user)))
   end  

   it"should have a welcome msg"do
   post :create,:user =>@attr
   flash[:success].should =~ /welcome to the sample app/i
   end

   it"should sign the user in"do
   post :create,:user=>@attr
   controller.should be_signed_in
   end
    
  end
#-----------------------------------------------
end

describe"'GET' edit"do

  before(:each) do
  @user =Factory(:user)
  test_sign_in(@user)
 end

it"should be successful"do
 get :edit, :id=>@user
 response.should be_success
end 

it"should havethe right title"do
 get :edit, :id=>@user
 response.should have_selector('title',:content=>"Edit user")
 end

 it "should have  link to change the gravater"do
  get :edit ,:id=>@user
  response.should have_selector('a',:href=>'http://gravatar.com/emails',
                                    :content=>"change")
 end
end
#-------------------------------------
describe"'Put' update "do 
  
   before(:each)do 
    @user=Factory(:user)
    test_sign_in(@user)
    end 
    #----------
     describe"failure"do 
       before(:each)do
        @attr={:name=>"",:email=>"",:password=>"",:password_confirmation=>""}
       end
   
     it "should render the edit page"do
        put:update,:id=>@user,:user=>@attr
        response.should  render_template('edit')
       end 

     it"should havethe right title"do
     put :update, :id=>@user,:user=>@attr
     response.should have_selector('title',:content=>"Edit user")
     end
  
    end 
  #--------------
   describe"successes"do
  
      before(:each)do
        @attr= {:name=>"New Name",:email=>"user@example.org",
               :password=>"foofoo",:password_confirmation=>"foofoo"}
      end
   
      it "should changethe user attribute"do
       put :update,:id=>@user,:user=>@attr
       user =assigns(:user)
       @user.reload
       @user.name.should == user.name   
       @user.email.should== user.email
       @user.encrypted_password.should == user.encrypted_password
     end

  it "should have a flash msg"do
    put :update,:id=>@user,:user=>@attr
      flash[:success].should =~/updated/
   end

end
  
end
#-----------------------------------

describe"authenticate of edit/update action"do
  
 before(:each)do
 @user=Factory(:user)
 end
 
 describe"for non-sign-ni user"do

 it "should deny accesse to 'edit'"do
  get:edit,:id=>@user
  response.should redirect_to(signin_path)
  flash[:notice].should =~/sign in/i
 end
 
it "should deny accesse to 'update'"do
  put:update,:id=>@user,:user=>{}
  response.should redirect_to(signin_path)
 end
 
end

 describe"for sign-in user"do
 
 before(:each)do
  wrong_user =Factory(:user,:email=>"user@example.net")
  test_sign_in(wrong_user)
 end 

 it"should require matching user for edit"do
  get:edit,:id=>@user
 response.should redirect_to(root_path) 
 end
 
it"should require matching user for update"do
  put:update,:id=>@user,:user=>{}
 response.should redirect_to(root_path)
 end
 

end



end
#---------------------------------------
end























