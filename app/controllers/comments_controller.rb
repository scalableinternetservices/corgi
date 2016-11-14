class CommentsController < ApplicationController
	before_action :set_event

	def create  
	  @comment = @event.comments.build(comment_params)
	  @comment.user_id = current_user.id

	  if @comment.save
	     create_notification @event, @comment
	     redirect_back(fallback_location: root_path)
	  else
	    flash[:alert] = "Comment post unsuccessful :("
	    render root_path
	  end
	end

	def destroy
    	@comment = @event.comments.find(params[:id])

	    if @comment.user_id == current_user.id
	      @comment.delete
	    end

	    flash[:notice] = 'Comment deleted.'
	    redirect_to root_path
  	end

	private
		def comment_params  
		  params.require(:comment).permit(:content)
		end

		def create_notification(event, comment)
    		return if event.user.id == current_user.id
    		Notification.create(user_id: event.user.id,
                        notified_by_id: current_user.id,
                        event_id: event.id,
                        notice_type: Notification.notice_types[:comment])
  		end 

		 
		def set_event 
		  @event = Event.find(params[:event_id])
		end 
end
