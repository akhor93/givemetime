class AdminsController < ApplicationController
  before_filter :require_admin

  def new
  end

  def show
  	@users = User.all
  	@todos = Todo.all
  	@activities = Activity.all
  	@events = Event.all
  end
end
