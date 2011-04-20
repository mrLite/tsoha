class MembersController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @members = @project.members.all
  end
  
  def add
    @project = Project.find(params[:project_id])
    @users = User.all
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
        format.xml  { render :xml => @member, :status => :created, :location => @member }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end
end