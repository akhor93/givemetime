class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by_email(params[:email])
  	if user && user.authenticate(params[:password])
  		session[:userid] = user.id
  		redirect_to rooturl, notice: "Logged In!"
  	else
  		flash[:error] = "Wrong Uername or Password"
  		redirect_to rooturl
  	end
  end

  def destroy
  	session[:userid] = nil
  	redirect_to rooturl, notice: "Logged Out"
  end
end
