class RelationshipsController < ApplicationController
	before_action :signed_in_user

	def follow_user
	    @user = User.find_by(user_name: params[:user_name])
	    if current_user == @user
	    	flash[:error] = "Can't follow yourself!"
	    	redirect_to root_path
	    elsif current_user.follow(@user)
	      respond_to do |format|
	        format.html { redirect_to profile_path(@user) }
	        format.js
	      end
	    end
	end

  	def unfollow_user
	    @user = User.find_by(user_name: params[:user_name])
	    if current_user == @user
	    	flash[:error] = "Can't unfollow yourself!"
	    	redirect_to root_path
	    elsif current_user.unfollow(@user)
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
                        identifier: user.id,
                        notice_type: 'comment')
  		end
end
