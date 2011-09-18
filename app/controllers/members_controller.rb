class MembersController < ApplicationController
  before_filter :can_add?, :except => [:index]
  def index
    @project = Project.find(params[:project_id])
    @members = @project.members.all
  end
  
  # Collects all registered users who aren't members of the project
  def add
    @project = Project.find(params[:project_id])
    @users = User.all.collect {|user| user unless user.projects.include?(@project)}.compact!
  end
  
  def new
    @project = Project.find(params[:project_id])
    @user = User.find(params[:user_id])
    @member = @project.members.new
    
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @project = Project.find(params[:project_id])
    @member = @project.members.new(params[:member])
    
    respond_to do |format|
      if @member.save
        format.html { redirect_to(@project, :notice => 'Member was successfully added.') }
      else
        format.html { render :action => "new" }
      end
    end
  end
end