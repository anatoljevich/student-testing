class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.column :name, :string, :limit => 24
    end
  end

  def self.down
    drop_table :groups
  end
end
