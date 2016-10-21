class InvitesController < ApplicationController
	before_action :signed_in_user

	def create
		event = Event.find(params[:event_id])
	    current_user.join(event)
	    redirect_to current_user
	end

	def destroy
	    event = Invite.find(params[:id]).event
	    current_user.leave(event)
	    redirect_to current_user
	end
end