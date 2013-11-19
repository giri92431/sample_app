require 'spec_helper' 


describe User do #1

before(:each)do
@attr = {:name=>"example users",
         :email=>"user@example.com",
         :password=>"foobar",
         :password_confirmation=>"foobar"
         }
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

#-----------------------------------------------------
describe "password should have a password" do
 
before(:each)do
 @user =User.new(@attr)
end

it "should have a password" do
 @user.should respond_to(:password)
end


it "should have apssword conf "do
@user.should respond_to(:password_confirmation)
end
end


#-----------------------------------------------------
describe "password validation "do
 

it "should aquire password"do
User.new(@attr.merge(:password=>"",:password_confirmation=>"")).
should_not be_valid
end

it "should require a matchin conf"do
User.new(@attr.merge(:password_confirmation =>"invalid")).
should_not be_valid
end


it"should reject short passwor"do
short="a" * 5
hash =@attr.merge(:password=>short,:password_confirmation=>short)
User.new(hash).should_not be_valid
end

it"should reject long passwor"do
long="a" * 41
hash =@attr.merge(:password=>long,:password_confirmation=>long)
User.new(hash).should_not be_valid
end
end

#-----------------------------------------------------
describe "password encription"do #3

before (:each)do
@user=User.create!(@attr)
end

it "should have an eincripted password attribue" do
@user.should respond_to(:encrypted_password)
end

it "should set encript passqord attribut" do
@user.encrypted_password.should_not be_blank
end

it"should have a salt "do
@user.should respond_to(:salt)
end

#----------------------------------------------------------
describe"has password method"do #4

it"should exist"do
@user.should respond_to(:has_password?)
end

it "should return true if the password match" do
@user.has_password?(@attr[:password]).should be_true
end

it"should return false"do
@user.has_password?("invalid").should be_false
end
#-------------------------------------------------------
describe "authendicate method" do

it "should exist"do
User.should respond_to(:authenticate)
end

it "should return nill on email password misss match"do
User.authenticate(@attr[:email],"wrongpass").should be_nil
end

it"should returt nill for an email address with no user"do
User.authenticate("bar@foo.com",@attr[:password]).should be_nil
end

it "should returnthe email/password match" do
User.authenticate(@attr[:email],@attr[:password]).should == @user
end


end
#-----------------------------------------------------

end #3
end #4
#-----------------------------------------------------------
describe"micropost association"do #5
 before(:each)do
  @user=User.create(@attr)
  @mp1=Factory(:micropost,:user=>@user,:created_at =>1.day.ago)
  @mp2=Factory(:micropost,:user=>@user,:created_at =>1.hour.ago)
 end

  it"shohould have a micropost attributes"do
   @user.should respond_to(:microposts)
  end
  

   it"should have the rit micropost int he rit order"do
    @user.microposts.should == [@mp2,@mp1]
   end
  
   it"should destory associated microposts"do
    @user.destroy
     [@mp1,@mp2].each do|micropost|

     lambda do
      Micropost.find(micropost)
      end.should raise_error(ActiveRecord::RecordNotFound)
     end
    end
  #-------
   describe"status feed"do
     
    it "should have a feed"do
     @user.should respond_to(:feed)
     end

     it "should include user microposts"do
     @user.feed.should include(@mp1)
     @user.feed.should include(@mp2)
     end

     it"should not include a different users microposat"do
      mp3 =Factory(:micropost,
                   :user=> Factory(:user,:email=> Factory.next(:email))) 
      @user.feed.should_not include(mp3)
      end

     it"should include micropost of followed user"do
      followed = Factory(:user,:email =>Factory.next(:email))
      mp3=Factory(:micropost, :user=>followed)
      @user.follow!(followed)
      @user.feed.should include(mp3)
     end 


      
   end
  #-----------------
end  #5
#--------------------------------------
  describe "relationships"do
    
   before(:each) do
   @user=User.create!(@attr)
   @followed =Factory(:user)
   end
   
    it"should have a relationship method"do
    @user.should respond_to(:relationships)
    end

    
   it"should have a folowing method"do
   @user.should respond_to(:following)
   end

   it"should folloe another user"do
   @user.follow!(@followed)
   @user.should be_following(@followed)
   end

  it"should include the folllowed user in th following array"do
  @user.follow!(@followed)
  @user.following.should include(@followed)
  end

  it "shoulf have an unfollow! method"do
   @user.should respond_to(:unfollow!)
   end

  it"should unfollow user"do
  @user.follow!(@followed)
  @user.unfollow!(@followed)
  @user.should_not be_following(@followed)
  end


 it"should have a reverse relationship method" do
  @user.should respond_to(:reverse_relationships)
 end
  
 it"should have a followers method"do
 @user.should respond_to(:followers)
 end

it"should include the folllower  in th following array"do
  @user.follow!(@followed)
  @followed.followers.should include(@user)
  end


  
  

 










  end

 #-------------------------------------
end #1





