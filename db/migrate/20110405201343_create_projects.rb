class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :url
      t.text :description
      t.string :visibility
      t.datetime :deadline

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
