require 'spec_helper'

describe MicropostsController do #1
render_views

#--------------
 describe"accesses controller"do

   it"should deny access to create "do
    post :create
    response.should redirect_to(signin_path)
    end


   it "should deny accesses to destory"do
   delete :destroy, :id => 1
   response.should redirect_to(signin_path)

   end
end

#---------------------------

describe"post create"do
  before(:each)do
   @user=test_sign_in(Factory(:user))
  end
  #----
  describe"failure"do
     
     before(:each)do
     @attr ={:content=>""}
     end
 
   it"should not create the micropost"do
    lambda do
    post:create,:micropost=>@attr
    end.should_not change(Micropost,:count)
   end

    it"should re-render the home page "do
    post :create,:micropost => @attr
    response.should render_template('pages/home')
    end
  end
  #-----
  describe"success"do
   before(:each)do
     @attr ={:content=>"Lorem ipsum dolor sit amet"}
     end
 
   it" should create a micropost "do
    lambda do
    post:create ,:micropost=>@attr
    end.should change(Micropost,:count).by(1)
   end
   
    it"should redirect to tr root path"do
     post:create ,:micropost=>@attr
     response.should redirect_to(root_path)
     end

    it"should have flash successes msg"do
    post :create,:micropost=>@attr
    flash[:success].should=~/micropost created/i
    end
  

  end
end
#----------------------



















#---------------------------
end#1
