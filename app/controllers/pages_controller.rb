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
      @feed_items = Event.from_users_followed_by(current_user).tagged_with(params[:search]).paginate(page: params[:page])
      @search_query = params[:search]
      render 'pages/home'
    end
  end

  def help
  end

  def about
  end
end
