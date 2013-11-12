class UsersController < ApplicationController
  
  def show 
  @user =User.find(params[:id])
  @title=@user.name
  end

  def new
   @user =User.new
   @title="sign up"

  end

  def create 
   
   @user =User.new(params[:user])
   if @user.save
     sign_in @user
     redirect_to @user,:flash=>{:success=> "welcome to the sample app" }
   
    else
    
    @title="sign up"
   render 'new'
  end
  end
end
