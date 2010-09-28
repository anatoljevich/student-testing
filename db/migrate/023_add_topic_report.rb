class AddTopicReport < ActiveRecord::Migration
  def self.up
    add_column :exam_entities, :topic_result, :string, :limit => 512
    change_column :exam_entities, :result, :string, :limit => 1024    
  end

  def self.down
    remove_column :exam_entities, :topic_result
    change_column :exam_entities, :result, :string, :limit => 4096    
  end
end
