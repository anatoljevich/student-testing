class AddFio < ActiveRecord::Migration
  def self.up
    add_column :authors, :fio, :string
  end

  def self.down
    remove_column :authors, :fio
  end
end
