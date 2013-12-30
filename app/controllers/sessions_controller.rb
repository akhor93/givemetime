class SessionsController < ApplicationController
  layout :choose_layout

  def new
    @user = User.new
  end

  def create
    user = User.find_by_email(params[:session][:email])
  	respond_to do |format|
  		if user && user.authenticate(params[:session][:password])
  			if params[:session][:remember_me]
          cookies.permanent[:auth_token] = user.auth_token
        else
          cookies[:auth_token] = user.auth_token
        end
  			format.js {render :redirect} #javascript to do the redirect
  		else
  			format.js {}
  		end
  	end
  end

  def destroy
  	cookies.delete(:auth_token)
  	redirect_to root_url, notice: "Logged Out"
  end

  private
  def choose_layout
  	(request.xhr?) ? nil : 'application'
  end
end
