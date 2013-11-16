require 'spec_helper'

describe Micropost do
  before(:each)do
    @user =Factory(:user)
   @attr={:content =>"lorem ispum"}
  end

it"should create a instancewith valid attributes"do
Micropost.create!(@attr)
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



end
