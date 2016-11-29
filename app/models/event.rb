class Event < ApplicationRecord
  belongs_to :user
  #location is geocoded

  has_attached_file :picture, styles: { :large => '640x400#' }
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
  geocoded_by :location
  after_validation :geocode

  has_many :guest_relationships, class_name: "Invite",
                                  foreign_key: "event_id",
                                  dependent: :destroy

  has_many :guests, through: :guest_relationships

  has_many :comments, dependent: :destroy

  default_scope -> { order(created_at: :desc)}
  validates :title,  presence: true, length: { maximum: 20 }
  validates :user_id, presence: true
  validates :date, presence: true
  validates :location, presence: true
  acts_as_taggable_on :tags

  has_many :likes


  def self.from_users_followed_by(user)
    follower_ids = user.followers.ids
    includes(:user,:guests,:comments,:tags).where("user_id IN (?) OR user_id = ?", user.followers, user.id)
      # followed_user_ids = "SELECT followed_id FROM relationships
      #                      WHERE follower_id = :user_id"         #the users the user follow
      # where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
      #     user_id: user.id)
  end


  def self.can_be_seen_events(user)
    friend_ids = user.friends.map{|f| f.id}
    includes(:user,:guests,:comments,:tags).where("user_id IN (?) OR isprivate = ? OR user_id = ?", friend_ids, 0, user.id)
    # friend_ids = "SELECT A.followed_id FROM
    #               relationships A INNER JOIN relationships B
    #               ON A.follower_id = B.followed_id
    #               WHERE A.followed_id = B.follower_id AND A.follower_id = :user_id"
    # where("user_id IN (#{friend_ids}) OR isprivate = 0 OR user_id = :user_id", user_id: user.id)
  end

  def self.home_page_events(user)
    follower_ids = user.followers.ids
    friend_ids = user.friends.map{|f| f.id}
    queried_ids = follower_ids | friend_ids

    includes(:user,:guests,:comments,:tags).where("user_id IN (?) OR isprivate = ? OR user_id = ?", 
      queried_ids, 0, user.id)


    # friend_ids = "SELECT A.followed_id FROM
    #               relationships A INNER JOIN relationships B
    #               ON A.follower_id = B.followed_id
    #               WHERE A.followed_id = B.follower_id AND A.follower_id = :user_id"
    # followed_user_ids = "SELECT followed_id FROM relationships
    #                        WHERE follower_id = :user_id"         #the users the user follow
    # where("user_id IN (#{friend_ids}) OR (user_id IN (#{followed_user_ids}) AND isprivate = 0) OR user_id = :user_id", user_id: user.id)
  end

  def self.all_events_from_friends(user)
    friend_ids = user.friends.map{|f| f.id}

    includes(:user,:guests,:comments,:tags).where("user_id IN (?) OR isprivate = ? OR user_id = ?", 
      friend_ids, 0, user.id)
    # friend_ids = "SELECT A.followed_id FROM
    #               relationships A INNER JOIN relationships B
    #               ON A.follower_id = B.followed_id
    #               WHERE A.followed_id = B.follower_id AND A.follower_id = :user_id"
    # where("user_id IN (#{friend_ids}) OR user_id = :user_id", user_id: user.id)
  end

end
