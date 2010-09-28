class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table "authors" do |t|
      t.column :login,                     :string, :limit => 20
#      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
#      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
    end
  end

  def self.down
    drop_table "authors"
  end
end
