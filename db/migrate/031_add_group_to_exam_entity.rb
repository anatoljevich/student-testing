class AddGroupToExamEntity < ActiveRecord::Migration
  def self.up
    remove_column :exam_entities, :group
    add_column :exam_entities, :group_id, :integer
  end

  def self.down
    add_column :exam_entities, :group, :string
    remove_column :exam_entities, :group_id
  end
end
