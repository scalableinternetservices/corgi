class RelationshipsController < ApplicationController
	before_action :signed_in_user


	def follow_user
	    @user = User.find_by(user_name: params[:user_name])
	    if current_user.follow(@user)
	      respond_to do |format|
	        format.html { redirect_to profile_path(@user) }
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
end
