class CreateDisciplines < ActiveRecord::Migration
  def self.up
    create_table :disciplines do |t|
      t.column :name, :string, :limit => 40
    end
  end

  def self.down
    drop_table :disciplines
  end
end
