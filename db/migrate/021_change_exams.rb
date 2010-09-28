class ChangeExams < ActiveRecord::Migration
  def self.up
    remove_column :exams, :discipline_id
    remove_column :exams, :questions_count
  end

  def self.down
  end
end
