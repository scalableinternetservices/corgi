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
        if params[:search][0] == '#'
          @feed_items = Event.from_users_followed_by(current_user).tagged_with(params[:search]).paginate(page: params[:page])
        else 
          @feed_items = Event.near(params[:search], 5).paginate(page: params[:page])
        end
      end
      @search_query = params[:search]
      render 'pages/home'
    end
  end

  def friend
    if signed_in?
      @temp = Event.from_users_friend(current_user)
      @temp.sort_by{|e| e.created_at}
      @friend_events = @temp.paginate(page: params[:page])
      @user = current_user
      #render 'pages/friend'
    end
  end

  def help
  end

  def about
  end
end
