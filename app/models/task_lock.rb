class TaskLock < ActiveRecord::Base
  belongs_to :task
  belongs_to :user
  
  validates_uniqueness_of :task_id, :scope => [:user_id], :message => "You cannot add the same task to same user twice!"
end
