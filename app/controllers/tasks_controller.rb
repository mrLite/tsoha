class TasksController < ApplicationController
  before_filter :authorize, :except => :show
  before_filter :can_add?, :except => :show
  
  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @project = Project.find(params[:project_id])
    @task = @project.tasks.new
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to(@project, :notice => 'Task was successfully created.') }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])
    
    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to(@project, :notice => 'Task was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(@project) }
      format.xml  { head :ok }
    end
  end
end
