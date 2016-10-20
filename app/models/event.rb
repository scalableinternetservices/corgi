class Event < ApplicationRecord
  belongs_to :user
  #location is geocoded
  geocoded_by :location
  after_validation :geocode

  default_scope -> { order(created_at: :desc)}
  validates :user_id, presence: true
  validates :date, presence: true
  validates :location, presence: true
  acts_as_taggable_on :tags

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end
end
