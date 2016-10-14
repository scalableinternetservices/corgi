class PagesController < ApplicationController
  def home
  	if signed_in?
  		@event = current_user.events.build 
  		@feed_items = current_user.feed.paginate(page: params[:page])
  	end
  end

  def help
  end

  def about
  end
end
