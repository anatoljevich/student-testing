class ModifyExamEntities < ActiveRecord::Migration
  def self.up
    add_column :exam_entities, :correct_count, :integer, :default => 0
    add_column :exam_entities, :questions_count, :integer, :default => 0    
  end

  def self.down
    remove_column :exam_entities, :correct_count
    remove_column :exam_entities, :questions_count
  end
end
