class SessionsController < ApplicationController
  def new
  @title="sign in"
  end
  #------------------------- 
  def create
   user = User.authenticate(params[:session][:email],
                            params[:session][:password])
    if user.nil?
     @title="sign in"
     flash.now[:error]="invalid email/password combination"
     render 'new'
    
    else
    
    end
   
  end
#-----------------
   def destory
   end  

end
