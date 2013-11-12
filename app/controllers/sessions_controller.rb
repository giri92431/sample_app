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
      sign_in user
      redirect_to user
    end
   
  end
#-----------------
   def destory
   end  

end
