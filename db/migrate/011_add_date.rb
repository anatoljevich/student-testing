class AddDate < ActiveRecord::Migration
  def self.up
    add_column :exam_entities, :created_at, :date
  end

  def self.down
    remove_column :exam_entities, :created_at    
  end
end
