class NotificationsController < ApplicationController
  def link_through
  	 @notification = Notification.find(params[:id])
  	 @notification.update read: true
  	 redirect_to event_path @notification.event
  end

  def index  
  	@notifications = current_user.notifications
  end
end
