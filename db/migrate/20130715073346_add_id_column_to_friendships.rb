class AddIdColumnToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :id, :primary_key
  end
end
