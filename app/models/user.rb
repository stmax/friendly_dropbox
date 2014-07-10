class User < ActiveRecord::Base

  has_many :friendships, :conditions => {:is_active => true }
  has_many :user_friends, :through => :friendships, :source => :friend

  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id', :conditions => {:is_active => true }
  has_many :user_inverse_friends, :through => :inverse_friendships, :source => :user

  has_many :friendships_invitees, :class_name => 'Friendship', :foreign_key => 'user_id', :conditions => {:is_active => false }
  has_many :invitees, :through => :friendships_invitees, :source => :friend

  has_many :inverse_friendships_inviters, :class_name => 'Friendship', :foreign_key => 'friend_id', :conditions => {:is_active => false }
  has_many :inviters, :through => :inverse_friendships_inviters, :source => :user

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable, :omniauth_providers => [:facebook, :twitter]

  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid, :name

  validates :name, :presence => true

  def friends
    self.user_friends + self.user_inverse_friends
  end

  def friend?(user)
    ! Friendship.get_active_friendship_relation(self.id, user.id).nil?
  end

  def invitee?(user)
    ! Friendship.get_invitee_relation(self.id, user.id).nil?
  end

  def inviter?(user)
    ! Friendship.get_inviter_relation(self.id, user.id).nil?
  end

  def self.search_new_friends(params)
    if params[:email].present? && params[:full_name].present?
      result = User.where("email like ? and name like ?", "%#{params[:email]}%", "%#{params[:full_name]}%")
    elsif params[:email].present?
      result = User.where("email like ?", "%#{params[:email]}%")
    elsif params[:full_name].present?
      result = User.where("name like ?", "%#{params[:full_name]}%")
    end
    result
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         password:Devise.friendly_token[0,20]
      )
    end
    user
  end

  def self.find_for_twitter_oauth access_token
    if user = User.where(:url => access_token.info.urls.Twitter).first
      user
    else
      User.create!(:provider => access_token.provider, :url => access_token.info.urls.Twitter, :username => access_token.info.name, :nickname => access_token.extra.raw_info.domain, :email => "#{access_token.extra.raw_info.screen_name}@tw.com", :password => Devise.friendly_token[0,20])
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end
