class PasswordResetsController < ApplicationController
  def create
  	@user = User.find_by_email(params[:email])
  	respond_to do |format|
			@user.send_password_reset if @user
			format.js {}
  	end
  end

  def edit
  	@user = User.find_by_password_reset_token!(params[:id])
  end

  def update
  	@user = User.find_by_password_reset_token!(params[:id])
  	respond_to do |format|
  		if @user.password_reset_sent_at < 2.hours.ago
  			format.js { render 'expired' }
  		elsif @user.update_attributes(params[:user])
				format.html { redirect_to root_url }
			else
				format.js {}
  		end
  	end
  end
end
