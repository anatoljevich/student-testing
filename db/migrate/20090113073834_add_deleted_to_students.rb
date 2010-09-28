class AddDeletedToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :deleted, :boolean, :default => false
  end

  def self.down
    remove_column :students, :deleted
  end
end
