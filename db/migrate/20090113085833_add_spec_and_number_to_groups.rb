class AddSpecAndNumberToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :spec, :string, :limit => 16
    add_column :groups, :number, :integer, :limit => 1
    Group.find(:all).each {
      |g|
      array = g[:name].split("-")
      g.spec = array[0].chars
      g.number = array[1].to_i
      g.save
    }
    remove_column :groups, :name
  end

  def self.down
    add_column :groups, :name, :string, :limit => 24

    Group.find(:all).each {
      |g|
      g.name = "#{g.spec}-#{g.number}"
      g.save
    }

    remove_column :groups, :spec
    remove_column :groups, :number
  end
end
