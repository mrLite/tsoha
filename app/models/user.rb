require 'digest/sha2'

class User < ActiveRecord::Base
  has_many :members, :dependent => :delete_all
  has_many :projects, :through => :members
  has_many :task_locks, :dependent => :delete_all
  
  belongs_to :user_role
  
  validates :username, :presence => true, :uniqueness => true
  validates :password, :confirmation => true
  
  attr_accessor :password_confirmation
  attr_reader :password
  
  validate :password_must_be_present
  
  class << self
    def authenticate(username, password)
      if user = find_by_username(username)
        if user.encrypted_password == encrypt_password(password, user.password_salt)
          user
        end
      end
    end

    def encrypt_password(password, password_salt)
      Digest::SHA2.hexdigest(password + "lolcats" + password_salt)
    end
  end
  
  def password=(password)
    @password = password
    
    if password.present?
      generate_salt
      self.encrypted_password = self.class.encrypt_password(password, password_salt)
    end
  end
  
  private

  def password_must_be_present
    errors.add(:password, "Missing password") unless encrypted_password.present?
  end
  
  def generate_salt
    self.password_salt = self.object_id.to_s + rand.to_s
  end
end