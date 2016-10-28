class InvitesController < ApplicationController
	before_action :signed_in_user

	def create
		event = Event.find(params[:event_id])
	    current_user.join(event)
	    redirect_to event
	end

	def destroy
	    event = Invite.find(params[:id]).event
	    current_user.leave(event)
	    redirect_to root_path
	end
end