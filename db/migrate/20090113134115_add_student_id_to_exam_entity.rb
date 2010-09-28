class AddStudentIdToExamEntity < ActiveRecord::Migration
  def self.up
    ExamEntity.destroy_all
    remove_column :exam_entities, :fio
    add_column :exam_entities, :student_id, :integer
  end

  def self.down
    remove_column :exam_entities, :student_id
    add_column :fio, :string, :limit => 64
  end
end
