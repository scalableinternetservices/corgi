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
      @location_results = @can_be_seen_events.near(params[:search].to_s, 5)
      @user_results = User.where("user_name LIKE ?", "%#{params[:search]}%")
      @search_query = params[:search]
    end
  end

  def explore
    if signed_in?
      @events_can_be_seen = Event.can_be_seen_events(current_user)

      # @events_top_likes: 10 events with top likes
      @events_top_likes = @events_can_be_seen.order(:likes_count).first(10)


      # @events_with_same_tags: the events with same tags as current_user
      current_user.events.each do |event|
        event.tag_list.each do |tag|
          if @events_with_same_tags
            @events_with_same_tags = @events_with_same_tags.or(@events_can_be_seen.tagged_with(tag))
          else
            @events_with_same_tags = @events_can_be_seen.tagged_with(tag)
          end
        end
      end

      # @events_nearby: the events(created within 3 days till now) which are near to the current_user's events
      @events_recent = @events_can_be_seen.where(:created_at => 3.days.ago..Time.now) 
      #@current_user_recent_events = current_user.events.where(:created_at => 7.days.ago..Time.now)
=begin
      @current_user_recent_events.each do |event|
        if @events_nearby 
          @events_nearby = @events_nearby.or(@events_recent.near(event.location, 100))
        else
          @events_nearby = @events_recent.near(event.location, 100)
        end
      end
=end
      @events_nearby = @events_recent.near(current_user.events.first.location, 100)

      # don't know how to union {@events_top_likes, @events_with_same_tags, @events_nearby} to @explore_events
      @user = current_user
      render 'pages/explore'
    end
  end

  def help
  end

  def about
  end
end
