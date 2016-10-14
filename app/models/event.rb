class Event < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc)}
  validates :user_id, presence: true
  validates :date, presence: true
  validates :location, presence: true
end
