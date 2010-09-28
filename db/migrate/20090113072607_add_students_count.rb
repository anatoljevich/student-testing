class AddStudentsCount < ActiveRecord::Migration
  def self.up
    add_column :groups, :students_count, :integer, :default => 0
  end

  def self.down
    remove_column :groups, :students_count
  end
end
