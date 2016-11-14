class InvitesController < ApplicationController
	before_action :signed_in_user

	def create
		event = Event.find(params[:event_id])
	    if current_user.join(event)
	    	create_notification(event)
	    end
	    redirect_to event
	end

	def destroy
	    event = Invite.find(params[:id]).event
	    current_user.leave(event)
	    redirect_to root_path
	end


	private
  		def create_notification(event)
    		Notification.create(user_id: event.user.id,
                        notified_by_id: current_user.id,
                        event_id: event.id,
                        notice_type: Notification.notice_types[:join])
  		end
end