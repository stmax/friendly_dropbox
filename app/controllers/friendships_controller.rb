class FriendshipsController < ApplicationController

  def assign
    @friendship = Friendship.get_friendship_relation(current_user.id, params[:id])
    if @friendship.present?
      @friendship.is_active = true
      flash[:message] = 'User added to friends list'
    else
      @friendship = current_user.friendships.build(:friend_id => params[:id], :is_active => 0)
      flash[:message] = 'User added to invite list'
    end
    @friendship.save
    redirect_to :back
  end

  def unassign
    @friendship = Friendship.get_friendship_relation(current_user.id, params[:id])
    if @friendship.present?
      @friendship.destroy
      flash[:message] = 'User unassigned from friends.'
    else
      flash[:message] = 'Error.'
    end
    redirect_to :back
  end

end
