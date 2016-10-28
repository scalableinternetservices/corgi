class PagesController < ApplicationController
  def home
  	if signed_in?
  		@event = current_user.events.build
  		@feed_items = current_user.feed.paginate(page: params[:page])
  	end
  end

  def search
    if signed_in?
      can_be_seen_events = Event.can_be_seen_events(current_user)
      @tag_results = can_be_seen_events.tagged_with(params[:search]).paginate(page: params[:page])
      @location_results = can_be_seen_events.tagged_with(params[:search]).paginate(page: params[:page])
      # @location_results = can_be_seen_events.near(params[:search], 5).paginate(page: params[:page])
      @user_results = User.where("user_name LIKE ?", "%#{params[:search]}%")
      @search_query = params[:search]
    end
  end

  def friend
    if signed_in?
      #@friends = User.friends(@user)
      @temp = Event.all_events_from_friends(current_user)
      @temp.sort_by{|e| e.created_at}
      @friend_events = @temp.paginate(page: params[:page])
      @user = current_user
      render 'pages/friend'
    end
  end

  def help
  end

  def about
  end
end
