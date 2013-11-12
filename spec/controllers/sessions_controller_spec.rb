require 'spec_helper'

describe SessionsController do
render_views
  
#-----------------------------------
  describe "GET 'new'" do
    it "returns http success" do
      get :new
      response.should be_success
    end

   
    it "should have the rit title "do
     get :new
    response.should have_selector('title',:content =>"sign in")
   end
  end
#------------------------------------------
describe"post create"do
  
   describe "failure"do
  
     before(:each)do
      @attr={:email=>"",:password=>""}
     end 
  
     it"should re-render the new page"do
     post :create,:session=>@attr
    response.should render_template('new')
    end

       it"should have a rit title"do
       post :create,:session=>@attr
       response.should have_selector('title',:content=>"sign in")
       end    


     it"should have a error msg"do
      post :create,:session =>@attr
     flash.now[:error].should =~/invalid/i
     end
 
end
end


end
