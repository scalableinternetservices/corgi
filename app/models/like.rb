class Like < ApplicationRecord
	belongs_to :user
  	belongs_to :event, counter_cache: true

  	validates_uniqueness_of :user, scope: :event
end
