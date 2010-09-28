class CreateExamEntityResults < ActiveRecord::Migration
  def self.up
    create_table :exam_entity_results do |t|
      t.column :exam_entity_id, :integer
      t.column :topic_id, :integer
      t.column :correct, :integer
      t.column :total, :integer
    end
  end

  def self.down
    drop_table :exam_entity_results
  end
end
