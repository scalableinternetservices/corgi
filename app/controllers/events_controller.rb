class EventsController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user, only: :destroy

	def create
		@event = current_user.events.build(event_params) 
		@event.tag_list = @event.description.split(" ").select {|word| word.start_with?("#")}
		if @event.save
			flash[:success] = "Event Created!"
			redirect_to current_user
		else
			render 'pages/home'

		end
	end

	def destroy
		@event.destroy
		redirect_to current_user
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
		ep[:tag_list] = ep[:description].split(" ").select {|word| word.start_with?("#")}
		if @event.update(ep)
			flash[:success] = "Event change successfully"
			redirect_to @event
		else
			render 'edit'
		end
	end

	private
	  	def event_params
	    	params.require(:event).permit(:title, :user, :date, :location,
	                                   :description, :tag_list)
	  	end

	  	def correct_user
	      @event = current_user.events.find_by_id(params[:id])
	      redirect_to root_path if @event.nil?
	    end
end
