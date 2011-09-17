class TaskLocksController < ApplicationController
  before_filter :can_add?
  
  def new
  end
      
  def create
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:task_id])
    @lock = @task.task_locks.new(params[:task_lock])
    
    respond_to do |format|
      if @lock.save
        format.html { redirect_to(@project, :notice => "Task was successfully allocated") }
      else
        format.html { redirect_to(@project, :notice => "Could not allocate task.") }
      end
    end
  end
end