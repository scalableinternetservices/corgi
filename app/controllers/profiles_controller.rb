class ProfilesController < ApplicationController  
    before_action :correct_user, only: [:edit, :update]
    before_action :signed_in_user

    def show
      @user = User.find_by(user_name: params[:user_name])
      if @user
        if current_user?(@user) || current_user.is_friend?(@user)
          @events = User.find_by(user_name: params[:user_name]).events.order('updated_at DESC')
        else
          @events = User.find_by(user_name: params[:user_name]).events.where("isprivate = 0").order('updated_at DESC')
        end
        # 'follow' action doesn't change the user's updated_at
        @newest_relationship = Relationship.where('follower_id = :user_id OR follower_id = :user_id', user_id: @user.id).order('updated_at DESC').first
        if @newest_relationship
          @newest_relationship_updated_at = @newest_relationship.updated_at 
        else 
          @newest_relationship_updated_at = Time.utc(1970, 1, 1, 0, 0, 0)
        end
        if not @events.size == 0
          @events_updated_at = @events.maximum(:updated_at)
        else 
          @events_updated_at = Time.utc(1970, 1, 1, 0, 0, 0)
        end
        fresh_when last_modified: [@user.updated_at.utc, @events_updated_at.utc, @newest_relationship_updated_at.utc].max, etag: [@user, @events.first, @newest_relationship]
        
      else
        redirect_to root_path
      end
    end

    def edit
      @user = User.find_by(user_name: params[:user_name])
      fresh_when last_modified: @user.updated_at.utc, etag: @user
    end

    def update
      @user = User.find_by(user_name: params[:user_name])
      if @user.update(profile_params)
        flash[:success] = 'Your profile has been updated.'
        redirect_to profile_path(@user.user_name)
      else
        @user.errors.full_messages
        flash[:error] = @user.errors.full_messages
        render :edit
      end
    end

    private
        def profile_params  
          params.require(:user).permit(:avatar, :background)
        end

        def correct_user
          @user = User.find_by(user_name: params[:user_name])
          redirect_to root_url unless current_user?(@user)
        end 
end