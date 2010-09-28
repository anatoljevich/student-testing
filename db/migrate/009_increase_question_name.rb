class IncreaseQuestionName < ActiveRecord::Migration
  def self.up
    change_column :questions, :name, :string, :limit => 128
  end

  def self.down
  end
end
