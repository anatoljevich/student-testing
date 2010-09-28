class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.column :surname, :string, :limit => 32
      t.column :name, :string, :limit => 32
      t.column :parent_name, :string, :limit => 32
      t.column :group_id, :integer
   end
   
   add_index :students, :group_id
   
  end

  def self.down
    drop_table :students
  end
end
