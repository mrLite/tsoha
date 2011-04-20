module ApplicationHelper
  def find_user
    User.find(session[:user_id])
  end
end
