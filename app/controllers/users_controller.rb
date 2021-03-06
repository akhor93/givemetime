class UsersController < ApplicationController
  before_filter :require_login, :only => [:show, :edit, :update]
  before_filter :require_logout, :only => [:new, :create]

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if params[:id].eql?(current_user.id.to_s)
      @user = User.find(current_user.id.to_s)

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
      end
    else
      redirect_to user_path(current_user.id)
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    beta_access_code = params["beta_access_code"]
    @user = User.new(params[:user])
    @user.confirmed = false
    @user.time_created = Time.now
    @user.admin = false
    tz =  ActiveSupport::TimeZone::MAPPING.index(params[:user][:time_zone])
    @user.time_zone = tz
    respond_to do |format|
      if beta_access_code != "PPEOTSOD"
        @user.errors.add(:base, "Incorrect Access Code")
        format.js {}
      elsif @user.save
        session[:user_id] = @user.id
        format.js {render 'sessions/redirect'} #javascript to do the redirect
      else
        format.js {}
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to calendar_index_path, notice: 'User was successfully updated.' }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
