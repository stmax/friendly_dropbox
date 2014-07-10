class UserController < ApplicationController
  def search
    @users = User.search_new_friends(params)
  end

  def friends
    @users = current_user.friends
  end

  def invitees
    @users = current_user.invitees
  end

  def inviters
    @users = current_user.inviters
  end
end
