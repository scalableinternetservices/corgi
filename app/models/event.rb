class Event < ApplicationRecord
  belongs_to :user
  #location is geocoded
  geocoded_by :location
  after_validation :geocode

  has_many :guest_relationships, class_name: "Invite",
                                  foreign_key: "event_id",
                                  dependent: :destroy
  has_many :guests, through: :guest_relationships

  default_scope -> { order(created_at: :desc)}
  validates :title,  presence: true, length: { maximum: 20 }
  validates :user_id, presence: true
  validates :date, presence: true
  validates :location, presence: true
  acts_as_taggable_on :tags


=begin
  def self.from_users_friend(user)
    friend_user_ids = "SELECT A.followed_id
                       FROM relationships A
                       WHERE A.follower_id = :user_id
                       AND EXISTS 
                       (SELECT * FROM relationships B
                       WHERE B.follower_id = A.followed_id AND B.followed_id = :user_id)"
    where("user_id IN (#{friend_user_ids})", user_id: user.id)
  end
=end

  #the public events from people the user follows
  def self.public_events_from_followings(user)   
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"         #the users the user follow

    where("(isprivate = 0 AND user_id IN (#{followed_user_ids}))", 
          user_id: user.id)
  end 

  def self.all_events_from_friends(user)
    frienda_user_ids = "SELECT friend_a FROM friends
                        WHERE friend_b = :user_id"
    friendb_user_ids = "SELECT friend_b FROM friends
                        WHERE friend_a = :user_id"
    where("(user_id IN (#{frienda_user_ids}) OR user_id IN (#{friendb_user_ids})) OR user_id = :user_id", user_id: user.id)
  end

  def self.from_users_followed_by(user)
      followed_user_ids = "SELECT followed_id FROM relationships
                           WHERE follower_id = :user_id"         #the users the user follow
      where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end



end
