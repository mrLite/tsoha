class UsersController < ApplicationController
  before_filter :authorize, :only => [:index, :show, :edit, :update, :destroy]
  before_filter :is_admin?, :only => [:index]
  before_filter :own_account?, :only => [:show, :edit, :update, :destroy]
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @projects = @user.projects.all

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.user_role = UserRole.find_or_create_by_role("user")

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to(root_url, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  # Returns true if the user account in params is the account of the logged in user.
  # Otherwise redirects to root url
  def own_account?
    if logged_in?
      user = User.find(session[:user_id])
      account = User.find(params[:id])
      if user.id == account.id or user.user_role.role == "administrator"
        return true
      end
    end
    redirect_to root_url, :notice => "You're not allowed to access this user account"
  end
end
