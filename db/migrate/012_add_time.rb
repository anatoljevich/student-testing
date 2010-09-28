class AddTime < ActiveRecord::Migration
  def self.up
    change_column :exam_entities, :created_at, :timestamp
    add_column :exam_entities, :finished_at, :timestamp
  end

  def self.down
    change_column :exam_entities, :created_at, :date
    remove_column :exam_entities, :finished_at
  end
end
