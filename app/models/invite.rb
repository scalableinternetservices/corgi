class Invite < ApplicationRecord
	belongs_to :guest, class_name: 'User'
	belongs_to :event, class_name: 'Event'
 	validates :guest_id, presence: true
	validates :event_id, presence: true
end
