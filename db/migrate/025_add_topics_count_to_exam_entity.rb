class AddTopicsCountToExamEntity < ActiveRecord::Migration
  def self.up
    remove_column :exam_entities, :topic_result
    remove_column :exam_entities, :correct_count
    remove_column :exam_entities, :questions_count
    add_column :exam_entities, :success_topics, :integer, :limit => 1
    add_column :exam_entities, :total_topics, :integer, :limit => 1    
  end

  def self.down
    add_column :exam_entities, :correct_count, :integer, :default => 0
    add_column :exam_entities, :questions_count, :integer, :default => 0    
    add_column :exam_entities, :topic_result, :string, :limit => 512
    remove_column :exam_entities, :success_topics
    remove_column :exam_entities, :total_topics    
  end
end
