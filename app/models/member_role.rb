class MemberRole < ActiveRecord::Base
  has_many :members
    
  class << self
    def find_or_create_roles
      roles = []
      ["administrator", "user"].each do |role|
        roles << [self.find_or_create_by_role(role).role, self.find_or_create_by_role(role).id]
      end
      roles
    end
  end
end
