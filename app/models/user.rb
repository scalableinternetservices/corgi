class User < ApplicationRecord
    attr_accessor :remember_token

    has_many :events, dependent: :destroy
    has_many :active_relationships, class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed

    has_many :passive_relationships, class_name: "Relationship",
                                     foreign_key: "followed_id",
                                     dependent: :destroy
    has_many :followers, through: :passive_relationships, source: :follower
=begin
    has_many :friendship_bs, class_name: "Friend",
                             foreign_key: "friend_b",
                             dependent: :destroy
    has_many :friend_as, through: :friendship_bs, source: :friend_a

=end

    has_many :invite_relationships, class_name: "Invite",
                                  foreign_key: "guest_id",
                                  dependent: :destroy
    has_many :invites, through: :invite_relationships, source: :event

	
	before_save { self.email = email.downcase }

	validates :name,  presence: true, length: { maximum: 50 }
    validates :user_name, presence: true, length: { minimum: 4, maximum: 15 }
  	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

    def User.digest(string)
    	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    												  BCrypt::Engine.cost
    	BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
    	SecureRandom.urlsafe_base64
    end
    def remember
    	self.remember_token = User.new_token
    	update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(remember_token)
    	return false if remember_digest.nil?
    	BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
    	update_attribute(:remember_digest, nil)
    end

    def follow(other_user)
        active_relationships.create(followed_id: other_user.id)
        if other_user.following?(self)
            #add friendship
            Friend.create(friend_a: self.id, friend_b: other_user.id)
        end
    end

    def unfollow(other_user)
        active_relationships.find_by(followed_id: other_user.id).destroy
        #destroy friend
        if other_user.following?(self)
            Friend.find_by(friend_a: self.id, friend_b: other_user.id).destroy
            Friend.find_by(friend_a: other_user.id, friend_b: self.id).destroy
        end
    end

    def following?(other_user)
        following.include?(other_user)
    end

    def self.friends(user)
        frienda_ids = "SELECT friend_a FROM friends
                       WHERE friend_b = :user_id"
        friendb_ids = "SELECT friend_b FROM friends
                       WHERE friend_a = :user_id"
        where("id IN (#{frienda_ids}) OR id IN (#{friendb_ids})", user_id: user.id)
    end

    def isfriend?(user) 
        Friend.exists?(friend_a: self.id, friend_b: user.id) || Friend.exists?(friend_a: user.id, friend_b: self.id)
    end

    def feed
        Event.public_events_from_followings(self).or(Event.all_events_from_friends(self))
        #Event.from_users_followed_by(self)
    end

    def join(event)
        invite_relationships.create(event_id: event.id)
    end

    def leave(event)
        invite_relationships.find_by(event_id: event.id).destroy
    end

    def guest?(event)
        invites.include?(event)
    end
end
