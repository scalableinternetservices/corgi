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


    has_many :invite_relationships, class_name: "Invite",
                                  foreign_key: "guest_id",
                                  dependent: :destroy
    has_many :invites, through: :invite_relationships, source: :event

	
	before_save { self.email = email.downcase }

	validates :name,  presence: true, length: { maximum: 50 }
    validates :user_name, presence: true, length: { minimum: 4, maximum: 15 }
    validates :background, length: { maximum: 200 }
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
    end

    def unfollow(other_user)
        active_relationships.find_by(followed_id: other_user.id).destroy     
    end

    def following?(other_user)
        following.include?(other_user)
    end

    def isfriend?(other_user)
        following.include?(other_user) && followers.include?(other_user)
    end
    
=begin
    def friends
        #following.merge(followers)
        Relationship.where("follower_id = :user_id", user_id: self.id).select("followed_id").merge(
            Relationship.where("followed_id = :user_id", user_id: self.id).select("follower_id"))
    end

    def private_events_from_friends
        friends.includes(:events)
    end

    def public_events_from_following
        (following.includes(:events)).where("isprivate = 0")
    end

    def can_be_seen_events
        Event.where("isprivate = 0").or(private_events_from_friends)
    end

    def isfriend?(user)
        self.friends.include?(user)
    end
=end

    def feed
        Event.home_page_events(self)
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
