class IncreaseQuestionText < ActiveRecord::Migration
  def self.up
    change_column :questions, :text, :string, :limit => 2048    
  end

  def self.down
    change_column :questions, :text, :string, :limit => 1024        
  end
end
