class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships, :id => false do |t|
      t.integer :participant1_id
      t.integer :participant2_id
      t.boolean :is_active
    end
  end

  def self.down
    drop_table :friendships
  end
end
