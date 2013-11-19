require 'spec_helper'

describe RelationshipsController do #1

  describe "access controller"do
   it"should require signin for create"do
    post :create
    response.should redirect_to(signin_path)
   end

   it"should require sinin for destory"do
   delete :destroy, :id=> 1
   response.should redirect_to(signin_path)
  end

  
 end   

 describe"Post create"do
   before(:each)do
   @user=test_sign_in(Factory(:user))
   @followed =Factory(:user,:email =>Factory.next(:email))
   end

 it"should create a relationship"do
   lambda do
    post :create,:relationship=>{:followed_id=>@followed}
    response.should redirect_to(user_path(@followed))
    end.should change(Relationship,:count).by(1)
   end

   it"shoul create a relationship wit ajax"do
     lambda do
      xhr:post, :create, :relationship =>{:followed_id=> @followed }
      response.should be_success
      end.should change(Relationship, :count).by(1)
    end
  

 end
      
describe "Delete' destory'"do
   before(:each)do
   @user=test_sign_in(Factory(:user))
   @followed =Factory(:user,:email =>Factory.next(:email))
   @user.follow!(@followed)
   @relationship=@user.relationships.find_by_followed_id(@followed)
   end

  it"should destory a relationship"do
   lambda do
   delete:destroy,:id=>@relationship
   response.should redirect_to(user_path(@followed))
   end.should change(Relationship, :count).by(-1)
  end

    it"shoul destory a relationship wit ajax"do
     lambda do
      xhr:delete, :destroy, :id=>@relationship
      response.should be_success
      end.should change(Relationship, :count).by(-1)
    end
  

 

 end




































end #1
