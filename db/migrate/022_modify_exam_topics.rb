class ModifyExamTopics < ActiveRecord::Migration
  def self.up
    add_column :exam_topics, :exam_id, :integer
  end

  def self.down
    remove_column :exam_topics, :exam_id
  end
end
