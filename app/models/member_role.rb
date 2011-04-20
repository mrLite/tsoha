class MemberRole < ActiveRecord::Base
  has_many :members
  
  ROLES = MemberRole.find(:all, :order => "role DESC").collect { |role| [role.role, role.id] }
end
