class PagesController < ApplicationController
  def home
  	if signed_in?
  		@event = current_user.events.build
  		@feed_items = current_user.feed.paginate(page: params[:page])
  	end
  end

  def search
    if signed_in?
      @event = current_user.events.build 
      if params[:search].length > 0
        @can_be_seen_events = Event.events_can_been_seen_by(current_user)
        if params[:search][0] == '#'
          #@feed_items = Event.from_users_followed_by(current_user).tagged_with(params[:search]).paginate(page: params[:page])
          @feed_items = @can_be_seen_events.tagged_with(params[:search]).paginate(page: params[:page])
        else 
          @feed_items = @can_be_seen_events.near(params[:search], 5).paginate(page: params[:page])
        end
      end
      @search_query = params[:search]
      render 'pages/home'
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
