class SessionsController < ApplicationController
  layout :choose_layout

  def new
      @user = User.new
  end

  def create
  	respond_to do |format|
  		@user = User.authenticate(params[:session][:email], params[:session][:password])
  		if @user
  			session[:user_id] = @user.id
  			format.js {render :redirect} #javascript to do the redirect
  		else
  			format.js {}
  		end
  	end
  	
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to root_url, notice: "Logged Out"
  end

  private
  def choose_layout
  	(request.xhr?) ? nil : 'application'
  end
end
