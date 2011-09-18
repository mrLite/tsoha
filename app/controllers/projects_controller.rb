class ProjectsController < ApplicationController
  before_filter :authorize, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :can_access?, :only => [:show, :edit, :update, :destroy]
  before_filter :can_modify?, :only => [:edit, :update, :destroy]
  before_filter :is_creator?, :only => [:destroy]
  
  # GET /projects
  # GET /projects.xml
  def index
    @projects = Project.all(:conditions => {:visibility => "Public"})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])
    @members = @project.members.all
    @tasks = @project.tasks.all(:order => "status, priority, deadline")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => [@project, @members, @tasks] }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    user = User.find_by_id(session[:user_id])

    respond_to do |format|
      if @project.save
        @project.members.create(:user_id => user.id, :member_role_id => MemberRole.find_or_create_by_role("creator"))
        format.html { redirect_to(@project, :notice => 'Project was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(@project, :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def is_creator?
    project = Project.find(params[:id])
    member = project.members.find_by_user_id(session[:user_id])
    if member.member_role.role == "creator"
      return true
    end
    redirect_to project, :notice => "You're not allowed to destroy this project!"
  end
  
  # Redirects to root unless the project is public, or the user logged in is a member of the project
  def can_access?
    project = Project.find(params[:id])
    
    if logged_in?
      user = User.find(session[:user_id])
      unless user.projects.include?(project) or project.visibility == "Public"
        redirect_to root_url, :notice => "You're not authorized to access this project!"
      end
    elsif project.visibility != "Public"
      redirect_to root_url, :notice => "You're not authorized to access this project!"
    end
  end
  
  # Redirects to project unless the logged in user is either the creator or an administrator of the project, in which case returns true
  def can_modify?
    project = Project.find(params[:id])
    
    if logged_in?
      user = User.find(session[:user_id])
      if user.projects.include?(project)
        member = project.members.find_by_user_id(user)
        if (member.member_role.role == "creator" or member.member_role.role == "administrator")
          return true
        end
      end
    end
    redirect_to project, :notice => "You're not authorized to modify this project!"
  end
end
