class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :member_role_id
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
