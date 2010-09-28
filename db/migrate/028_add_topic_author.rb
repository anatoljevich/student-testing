class AddTopicAuthor < ActiveRecord::Migration
  def self.up
    add_column :topics, :author_id, :integer
  end

  def self.down
    remove_column :topics, :author_id
  end
end
