class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.column :discipline_id, :integer
      t.column :name, :string
    end
  end

  def self.down
    drop_table :topics
  end
end
