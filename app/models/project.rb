class Project < ActiveRecord::Base
  #default_scope :conditions => {:visibility => "Public"}
  
  has_many :members, :dependent => :delete_all
  has_many :project_members, :through => :members, :source => :user
  has_many :tasks, :dependent => :delete_all
  
  validates :name, :presence => true
end