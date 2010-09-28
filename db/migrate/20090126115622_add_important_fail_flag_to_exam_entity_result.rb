class AddImportantFailFlagToExamEntityResult < ActiveRecord::Migration
  def self.up
    add_column :exam_entity_results, :important_fail, :boolean, :default => false
  end

  def self.down
    remove_column :exam_entity_results, :important_fail
  end
end
