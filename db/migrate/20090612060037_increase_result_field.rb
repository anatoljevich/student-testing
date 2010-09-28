class IncreaseResultField < ActiveRecord::Migration
  def self.up
    change_column :exam_entities, :result, :string, :limit => 4096
  end

  def self.down
    change_column :exam_entities, :result, :string, :limit => 2048
  end
end
