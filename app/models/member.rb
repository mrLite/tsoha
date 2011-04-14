class Member < ActiveRecord::Base
  belongs_to :member_role
  belongs_to :project
  belongs_to :user
end
