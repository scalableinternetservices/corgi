class PagesController < ApplicationController
  def home
  	@event = current_user.events.build if signed_in?
  	@feed_items = current_user.feed.paginate(page: params[:page])
  end

  def help
  end

  def about
  end
end
