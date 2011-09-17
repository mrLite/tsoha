module ApplicationHelper
  def find_user
    User.find(session[:user_id])
  end
  
  def if_project_admin(&block)
    if logged_in?
      member = @project.members.find_by_user_id(session[:user_id])
      if member and (member.member_role.role == "creator" or member.member_role.role = "administrator")
        yield
      end
    end
  end
  
  def logged_in?
    session[:user_id] ? true : false
  end
end
