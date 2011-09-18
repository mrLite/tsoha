class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def logged_in?
    session[:user_id] ? true : false
  end
  
  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to login_url, :notice => "Please log in"
    end
  end
  
  def is_admin?
    user = User.find_by_id(session[:user_id])
    if user
      unless user.user_role.role == "administrator"
        flash[:notice] = "You're not authorized to view this!"
        redirect_to root_url
      end
    end
  end
  
  # Checks if the user logged in is authorized to modify the project
  def can_add?
    project = Project.find(params[:project_id])

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
