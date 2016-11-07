class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notified_by, class_name: 'User'
  belongs_to :event


  validates :user_id, :notified_by_id, :event_id, :identifier, :notice_type, presence: true
end
