class ChangeKeysToFriendships < ActiveRecord::Migration
  def up
    change_table :friendships do |t|
      t.remove :participant1_id, :participant2_id
      t.integer :user_id
      t.integer :friend_id
    end
  end

  def down
  end
end
