class AddQuestionsCount < ActiveRecord::Migration
  def self.up
    add_column :disciplines, :questions_count, :integer, :default => 0
#    Discipline.reset_column_information
#    Discipline.find(:all).each {
#      |d|
#      d.update_attribute :questions_count, d.questions(true).size
#    }
  end

  def self.down
    remove_column :disciplines, :questions_count
  end
end
