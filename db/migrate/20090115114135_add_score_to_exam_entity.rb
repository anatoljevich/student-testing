class AddScoreToExamEntity < ActiveRecord::Migration
  def self.up
    add_column :exam_entities, :score, :integer, :limit => 1
    add_column :exam_entities, :average, :integer, :limit => 1
  end

  def self.down
    remove_column :exam_entities, :score
    remove_column :exam_entities, :average
  end
end
