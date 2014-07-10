class Friendship < ActiveRecord::Base

  attr_accessible :friend_id, :user_id, :is_active

  belongs_to :user
  belongs_to :friend, :class_name => 'User'

  def self.get_friendship_relation(participant1_id, participant2_id)
    Friendship.bi_directional_equal_user(participant1_id, participant2_id).first
  end

  def self.get_active_friendship_relation(participant1_id, participant2_id)
    Friendship.bi_directional_equal_user(participant1_id, participant2_id).active.first
  end

  def self.get_invitee_relation(participant1_id, participant2_id)
    Friendship.equal_users(participant1_id, participant2_id).not_active.first
  end

  def self.get_inviter_relation(participant1_id, participant2_id)
    Friendship.inverse_equal_users(participant1_id, participant2_id).not_active.first
  end

  scope :bi_directional_equal_user, ->(participant1_id, participant2_id) { equal_users(participant1_id, participant2_id) or inverse_equal_users(participant1_id, participant2_id) }

  scope :inverse_equal_users, ->(participant1_id, participant2_id) { where('friend_id = ? and user_id = ?', participant1_id, participant2_id) }
  scope :equal_users, ->(participant1_id, participant2_id) { where('user_id = ? and friend_id = ?', participant1_id, participant2_id) }

  scope :active, -> { where(is_active: true) }
  scope :not_active, -> { where(is_active: false) }
end
