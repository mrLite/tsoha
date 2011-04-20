class Project < ActiveRecord::Base
  #default_scope :conditions => {:visibility => "Public"}
  
  has_many :members
  has_many :project_members, :through => :members, :source => :user
  has_many :tasks
  
  validates :name, :presence => true
end