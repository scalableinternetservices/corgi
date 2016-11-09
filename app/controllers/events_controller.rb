class EventsController < ApplicationController
	before_action :signed_in_user
	before_action :correct_user, only: :destroy

	def new
		@event = Event.new
	end

	def create
		@event = current_user.events.build(event_params) 
		@event.tag_list = @event.description.split(" ").select {|word| word.start_with?("#")} if @event.description
		@event.likes_count = 0
		if @event.save
			current_user.join(@event)
			if @event.isprivate == true
				flash[:success] = "Private Event Created!"
			else 
				flash[:success] = "Public Event Created!"
			end
			redirect_to @event
		else
			flash[:error] = @event.errors.full_messages.to_s
			redirect_to root_path
		end
	end

	def like
		@event = Event.find(params[:id])
		Like.create(event: @event, user: current_user)
		respond_to do |format|
      		format.html do
      			redirect_to :back
  			end
  			format.js
  		end
	end

	def destroy
		@event.destroy
		redirect_to profile_path(current_user.user_name)
	end

	def show
		@event = Event.find(params[:id])
	end

	def edit
		@event = Event.find(params[:id])
	end

	def update
		@event = Event.find(params[:id])
		ep = event_params
		ep[:tag_list] = ep[:description].split(" ").select {|word| word.start_with?("#")} if ep[:description]
		if @event.update(ep)
			flash[:success] = "Event updated!"
			redirect_to @event
		else
			flash[:error] = @event.errors.full_messages.to_s
			render 'edit'
		end
	end

	private
	  	def event_params
	    	params.require(:event).permit(:title, :user, :date, :location,
	                                   :description, :tag_list, :isprivate, :picture)
	  	end

	  	def correct_user
	      @event = current_user.events.find_by_id(params[:id])
	      redirect_to root_path if @event.nil?
	    end
end
