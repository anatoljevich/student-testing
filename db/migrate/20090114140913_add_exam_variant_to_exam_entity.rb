class AddExamVariantToExamEntity < ActiveRecord::Migration
  def self.up
    add_column :exams, :exam_variant, :string, :limit => 1
    add_column :exam_entities, :exam_variant, :string, :limit => 1
    Exam.find(:all).each { |e| e.update_attribute :exam_variant, 'a'}
    ExamEntity.find(:all).each { |e| e.update_attribute :exam_variant, 'a'}    
  end

  def self.down
    remove_column :exam_entities, :exam_variant
    remove_column :exams_entities, :exam_variant
  end
end
