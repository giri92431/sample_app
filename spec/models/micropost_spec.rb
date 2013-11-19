require 'spec_helper'

describe Micropost do
  before(:each)do
    @user =Factory(:user)
   @attr={:content =>"lorem ispum"}
  end

it"should create a instancewith valid attributes"do
 @user.microposts.create!(@attr)
end

describe"user association"do
 
 before(:each)do
  @micropost=@user.microposts.create(@attr)
 end 
 
  
 it"should have a user attribute"do
  @micropost.should respond_to(:user)
 end


  it"should have the rit associated user"do
   @micropost.user_id.should == @user.id
   @micropost.user.should == @user
  end 


end

  describe "validation" do
    it"should have a user id "do
     Micropost.new(@attr).should_not be_valid
    end
   
    it"should require a non blank content"do
      @user.microposts.build(:content =>"   ").should_not be_valid
     end

   it"should reject long content"do
    @user.microposts.build(:content =>"a"*141).should_not be_valid
   end

end
#---------------------------
 describe "from users followed by"do

 before(:each)do
 @other_user=Factory(:user,:email =>Factory.next(:email))
 @third_user=Factory(:user,:email =>Factory.next(:email))

 @user_post  =@user.microposts.create!(:content=>"foo")
 @other_post =@other_user.microposts.create!(:content=>"bar")
 @third_post =@third_user.microposts.create!(:content=>"baz")
 
 @user.follow!(@other_user)

 end
  
  it"should have a uer follow by method"do
   Micropost.should respond_to(:from_users_followed_by)
  end

  it"should includede th folloed users micropost"do
  Micropost.from_users_followed_by(@user).
  should include(@other_post)
  end


  it"should include the users own microost"do
  
  Micropost.from_users_followed_by(@user).
  should include(@user_post)

  end


  it"should include a n unfollowed users micropost"do
  Micropost.from_users_followed_by(@user).
  should_not include(@third_post)
  end


 end
#-------------------------
end

















