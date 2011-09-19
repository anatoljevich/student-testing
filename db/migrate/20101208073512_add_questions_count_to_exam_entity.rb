class AddQuestionsCountToExamEntity < ActiveRecord::Migration
  def self.up
    add_column :exam_entities, :questions_count, :integer
    add_column :exam_entities, :current_question_number, :integer
  end

  def self.down
    remove_column :exam_entities, :questions_count
    remove_column :exam_entities, :current_question_number
  end
end
