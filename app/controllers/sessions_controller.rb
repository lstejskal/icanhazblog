class SessionsController < ApplicationController
  # TODO don't display blog layout for these actions
  
  def new
  end

  def create  
    user = User.authenticate(params[:email], params[:password])  

    if user
      session[:user_id] = user.to_param 
      redirect_to root_url, :notice => "Logged in!"  
    else  
      flash.now.alert = "Invalid email or password"
      render "new"
    end  
  end  

  def destroy  
    session[:user_id] = nil  
    redirect_to root_url, :notice => "Logged out!"  
  end  

end
