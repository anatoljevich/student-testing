class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.column :discipline_id, :integer
      t.column :author_id, :integer      
      t.column :multivariant, :boolean, :default => false
      t.column :name, :string, :limit => 40
      t.column :text, :string
      t.column :answers, :string #in XML format
    end
  end

  def self.down
    drop_table :questions
  end
end
