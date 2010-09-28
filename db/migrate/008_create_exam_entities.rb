class CreateExamEntities < ActiveRecord::Migration
  def self.up
    create_table :exam_entities do |t|
      t.column :exam_id, :integer
      t.column :fio, :string, :limit => 64
      t.column :group, :string, :limit => 16
      t.column :result, :string #in XML format
      t.column :complete, :boolean, :default => false
    end
  end

  def self.down
    drop_table :exam_entities
  end
end
