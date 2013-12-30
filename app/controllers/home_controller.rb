class HomeController < ApplicationController
  def index
  	if logged_in?
  		redirect_to :controller => "calendar", :action => "index"
  	else
  		@user = User.new
  	end
  end
end
