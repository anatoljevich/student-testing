class CreateExamTopics < ActiveRecord::Migration
  def self.up
    create_table :exam_topics do |t|
      t.column :topic_id, :integer
      t.column :count, :integer
      t.column :passing_score, :integer
    end
  end

  def self.down
    drop_table :exam_topics
  end
end
