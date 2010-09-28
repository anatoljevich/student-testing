class AddImportantFlag < ActiveRecord::Migration
  def self.up
    add_column :exam_topics, :important, :boolean, :default => false
  end

  def self.down
    remove_column :exam_topics, :important
  end
end
