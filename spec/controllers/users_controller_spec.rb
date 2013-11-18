require 'spec_helper'

describe UsersController do
render_views

#----------------------
 describe"Get index"do
  describe "for non-sign in users"do
  
     it"should deny accesses"do
      get:index
      response.should redirect_to(signin_path)
     end
   end
    

 describe"for sign in users"do
   before(:each)do
   @user = test_sign_in(Factory(:user))
   Factory(:user,:email=>"another@example.com")
   Factory(:user,:email=>"another@example.net")
   30.times do
    Factory(:user,:email =>Factory.next(:email))
   
   end
   end

  it" should be succesful "do
  get:index
  response.should be_success
  end
  
it"shoud have the rit title"do
   get:index
   response.should have_selector('title',:content=>"all users")
  end

  it"should have an element fo each user"do
    get:index
    User.paginate(:page=>1).each do|user|
   response.should have_selector('li',:content =>user.name)
  end
 end  

 it"should paginate users"do
  
  get:index
  response.should have_selector('div.pagination')
  response.should have_selector('span.disabled',:content=>"Previous")
  response.should have_selector('a',:href=>"/users?page=2",:content=>"2")
  response.should have_selector('a',:href=>"/users?page=2",:content=>"Next")
 end  
  

 it"should have delete links for admins"do
 @user.toggle!(:admin)
 other_user =User.all.second
 get:index
 response.should have_selector('a',:href=>user_path(other_user),
                                    :content=>"delete")

 end
 
 it"should not have delete links for non admins"do
 other_user =User.all.second
 get:index
 response.should_not have_selector('a',:href=>user_path(other_user),
                                    :content=>"delete")

 end

end 

 



 
 end
#-------------------------

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

it"should show the use micropost"do
 mp1=Factory(:micropost,:user =>@user,:content =>"foo bar")
 mp2=Factory(:micropost,:user =>@user,:content =>"baz bar")
 get:show,:id =>@user
 response.should have_selector('span.content',:content => mp1.content)
 response.should have_selector('span.content',:content => mp2.content)
end

it "should paginate micropost"do
35.times {Factory(:micropost,:user=>@user,:content =>"foo bar")}
 get:show,:id=>@user
response.should have_selector('div.pagination')
end

it"should display micropost count "do
 10.times { Factory(:micropost,:user=>@user,:content=>"foo") }
 get :show,:id=>@user
 response.should have_selector('td.sidebar',
                                :content=>@user.microposts.count.to_s)
end

 #---
  describe "when signed in as another user"do
   it"should be success ful"do
     test_sign_in(Factory(:user,:email=>Factory.next(:email)))
     get :show,:id=>@user
     response.should be_success
   end
 




  end
 #------- 
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
describe"admin attribut "do
   before(:each)do
   @user=User.create(@attr)
   end



  it"should respond to admin attribute"do
   @user.should respond_to(:admin)
   end


      it"should not be an admin by default"do
      @user.should_not be_admin
      end
    
      it"should convertiale to an admine"do
       @user.toggle!(:admin)
       @user.should be_admin
       end
  




end
#--------------------------------
describe"delete destory"do
before(:each)do
@user =Factory(:user)
end
  #----
  describe"as a non-signied-in user"do

   it"should deny access"do 
   delete:destroy,:id=> @user
    response.should redirect_to(signin_path)
  end

  end
#-------------
   describe"as nonadmin user"do
    
    it "should protect the action"do
     test_sign_in(@user)
     delete :destroy,:id=>@user
     response.should redirect_to(root_path)

    end
   end
#-------

  describe"as an admin"do
  before(:each)do
   @admin=Factory(:user,:email=>"admin@example.com",:admin=>true)
   test_sign_in(@admin)
  end

  it "should destory the user"do
   lambda do
   delete :destroy,:id=>@user
   end.should change(User,:count).by(-1)
  end

 
  it"should redirect to users page"do
   delete :destroy,:id=>@user
   flash[:success].should =~/User destoryed/i
  response.should redirect_to(users_path)
  end

  it "should not be able to destory it self"do
   lambda do
   delete :destroy,:id=> @admin
   end.should_not change(User,:count)
   end

  

end

end
#------------------------------------
end























