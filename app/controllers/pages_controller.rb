class PagesController < ApplicationController
  def home
  	if signed_in?
  		@event = current_user.events.build
  		@feed_items = current_user.feed
  	end
  end

  def search
    if signed_in?
      @can_be_seen_events = Event.can_be_seen_events(current_user)
      @tag_results = @can_be_seen_events.tagged_with(params[:search])
      # @location_results = can_be_seen_events.tagged_with(params[:search])
      @location_results = can_be_seen_events.near(params[:search].to_s, 5)
      @user_results = User.where("user_name LIKE ?", "%#{params[:search]}%")
      @search_query = params[:search]
    end
  end

  def explore
    if signed_in?
      events_can_be_seen = Event.can_be_seen_events(current_user)

      @explore_events = []

      # @events_top_likes: 10 events with top likes
      @explore_events += events_can_be_seen.order(:likes_count).where.not(:user_id => current_user.id).first(10)

      # @events_with_same_tags: the events with same tags as current_user
      current_user.events.each do |event|
        @explore_events += Event.tagged_with(event.tag_list, :any => true).where.not(:user_id => event.user.id)
      end

      # @events_nearby: the events(created within 3 days till now) which are near to the current_user's events
      current_user.events.where(:created_at => 3.days.ago..Time.now).each do |event|
        @explore_events += events_can_be_seen.near(event.location, 100).where.not(:user_id => current_user.id)
      end
    end
  end

  def help
  end

  def about
  end
end
