class AdminsController < ApplicationController
  before_filter :require_admin

  def new
  end

  def show
  	@users = User.all
  end
end
