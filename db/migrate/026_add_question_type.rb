class AddQuestionType < ActiveRecord::Migration
  def self.up
    add_column :questions, :type, :string, :limit => 5
  end

  def self.down
    remove_column :questions, :type
  end
end
