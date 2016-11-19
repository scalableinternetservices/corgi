module NotificationsHelper
	def notification_message(notification)
   event = Event.find(notification.event_id) unless notification.event_id.nil?
	 case notification.notice_type.to_sym
  	 when :join
  	 	return "#{notification.notified_by.user_name} has joined your event #{event.title}"
  	 when :like
  	 	return "#{notification.notified_by.user_name} has liked your event #{event.title}"
  	 when :follow
  	 	return "#{notification.notified_by.user_name} has followed you"
  	 when :comment
  	 	return "#{notification.notified_by.user_name} has commented on your event #{event.title}"
  	 end
	end

  def cache_key_for_notification(notification)
    "notification-#{notification.id}-#{notification.updated_at}"
  end
end
