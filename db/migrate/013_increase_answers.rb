class IncreaseAnswers < ActiveRecord::Migration
  def self.up
    change_column :questions, :answers, :string, :limit => Tests::Config::max_answers_size
    change_column :questions, :text, :string, :limit => Tests::Config::max_question_size
  end

  def self.down
    change_column :questions, :answers, :string
    change_column :questions, :text, :string    
  end
end
