class AddAdminFlag < ActiveRecord::Migration
  def self.up
    add_column :authors, :admin, :boolean, :default => false
  end

  def self.down
    remove_column :authors, :admin
  end
end
