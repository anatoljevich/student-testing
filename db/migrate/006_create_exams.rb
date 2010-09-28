class CreateExams < ActiveRecord::Migration
  def self.up
    create_table :exams do |t|
      t.column :description, :string
      t.column :discipline_id, :integer
      t.column :questions_count, :integer
      t.column :duration, :integer
      t.column :passing_score, :integer
      t.column :active, :boolean, :default => false
    end
  end

  def self.down
    drop_table :exams
  end
end
