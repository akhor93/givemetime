class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include UsersHelper
  include CalendarHelper
  include EventHelper

  around_filter :user_time_zone, :if => :current_user

  def user_time_zone(&block)
  	Time.use_zone(current_user.time_zone, &block)
  end
end
