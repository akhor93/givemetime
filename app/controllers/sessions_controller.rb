class SessionsController < ApplicationController
  layout :choose_layout

  def new
  end

  def create
  	respond_to do |format|
  		user = User.authenticate(params[:session][:email], params[:session][:password])
  		if user
  			session[:user_id] = user.id
  			format.html { redirect_to user_path, notice: "Logged In!" }
  			format.js {render :redirect} #javascript to do the redirect
  		else
  			format.html { render :new}
  			format.js #defaults to create.js.erb
  			#format.json { render json: user.errors}
  			#flash[:error] = "Wrong Username or Password"
  			#render 'new'
  			#redirect_to root_url
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
