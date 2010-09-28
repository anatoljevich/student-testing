class AddCodeToStudent < ActiveRecord::Migration
  def self.up
    add_column :students, :code, :string, :limit => 8
  end

  def self.down
    remove_column :students, :code
  end
end
