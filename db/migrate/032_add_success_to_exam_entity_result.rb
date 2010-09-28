class AddSuccessToExamEntityResult < ActiveRecord::Migration
  def self.up
    add_column :exam_entity_results, :success, :boolean, :default => false
  end

  def self.down
    remove_column :exam_entity_results, :success
  end
end
