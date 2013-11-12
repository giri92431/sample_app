require 'spec_helper'

describe SessionsController do
render_views
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

end
