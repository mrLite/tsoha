class Project < ActiveRecord::Base
  has_many :members, :dependent => :delete_all
  has_many :project_members, :through => :members, :source => :user
  has_many :tasks, :dependent => :delete_all
  
  validates_presence_of :name, :deadline
end