class EnterTopics < ActiveRecord::Migration
  def self.up
    remove_column :disciplines, :questions_count
    rename_column :questions, :discipline_id, :topic_id
    add_column :topics, :questions_count, :integer, :default => 0
  end

  def self.down
    remove_column :topics, :questions_count
    rename_column :questions, :topic_id, :discipline_id
    add_column :disciplines, :questions_count, :integer
  end
end
