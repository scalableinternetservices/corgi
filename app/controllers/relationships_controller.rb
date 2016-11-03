class RelationshipsController < ApplicationController
	before_action :signed_in_user


	def follow_user
	    @user = User.find_by(user_name: params[:user_name])
	    if current_user.follow(@user)
	      create_notification @user
	      respond_to do |format|
	        format.html { redirect_to root_path }
	        format.js
	      end
	    end
	end

  	def unfollow_user
	    @user = User.find_by(user_name: params[:user_name])
	    if current_user.unfollow(@user)
	      respond_to do |format|
	        format.html { redirect_to root_path }
	        format.js
	      end
	    end
  	end


  	private
  		def create_notification (user)
    		Notification.create(user_id: user.id,
                        notified_by_id: current_user.id,
                        event_id: '#',
                        identifier: 'event_id',
                        notice_type: 'follow')
  		end
end
