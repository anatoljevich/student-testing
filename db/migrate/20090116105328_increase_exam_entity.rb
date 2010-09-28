class IncreaseExamEntity < ActiveRecord::Migration
  def self.up
    change_column :exam_entities, :result, :string, :limit => 2048
  end

  def self.down
    change_column :exam_entities, :result, :string, :limit => 1024    
  end
end
