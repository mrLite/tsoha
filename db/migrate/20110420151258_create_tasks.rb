class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :project_id
      t.text :description
      t.integer :priority
      t.string :status
      t.datetime :deadline
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
