class AuthorsRightsForTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :public, :boolean, :default => false
  end

  def self.down
    remove_column :topics, :public
  end
end
