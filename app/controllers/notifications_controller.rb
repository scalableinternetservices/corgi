class NotificationsController < ApplicationController
  def index  
  	@notifications = current_user.notifications
  end	

  def link_through
  	 @notification = Notification.find(params[:id])
  	 @notification.update read: true
  	 if @notification.notice_type.to_sym == :follow
  	 	redirect_to profile_path(User.find(@notification.notified_by_id).user_name)
  	 else
  	 	redirect_to Event.find(@notification.event_id)
  	 end
  end
end
