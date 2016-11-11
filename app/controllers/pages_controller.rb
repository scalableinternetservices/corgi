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
      @tag_results = @can_be_seen_events.tagged_with(params[:search]).includes(:user)
      #@tag_results = @can_be_seen_events.tagged_with(params[:search]).joins(:user).select("events.*, users.name as user_name")
      @location_results
      if params[:search].present? and Geocoder.coordinates(params[:search])
        @location_results = @can_be_seen_events.near(params[:search], 5).includes(:user)
        #@location_results = @can_be_seen_events.near(params[:search], 5)
      end
      @user_results = User.where("user_name LIKE ?", "%#{params[:search]}%")
      @search_query = params[:search]
    end
  end

  def explore
    if signed_in?
      events_can_be_seen = Event.can_be_seen_events(current_user)

      explore_event_ids = []

      # @events_top_likes: 10 events with top likes
      explore_event_ids += events_can_be_seen.unscoped.order(likes_count: :desc).where.not(:user_id => current_user.id).ids.first(10)

      # @events_with_same_tags: the events with same tags as current_user
      current_user.events.each do |event|
        explore_event_ids += Event.tagged_with(event.tag_list, :any => true).where.not(:user_id => event.user.id).ids
      end

      current_user.events.where(:created_at => 3.days.ago..Time.now).each do |event|
        if event.location.present? and Geocoder.coordinates(params[:search])
          nearby_events = events_can_be_seen.near(event.location, 50).where.not(:user_id => current_user.id)
          explore_event_ids += (nearby_events.map {|event| event.id})
        end
      end
      @explore_events = Event.where(:id => explore_event_ids).distinct.includes(:user)
    end
  end

  def help
  end

  def about
  end
end
