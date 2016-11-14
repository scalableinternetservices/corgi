class ProfilesController < ApplicationController  
    before_action :correct_user, only: [:edit, :update]
    before_action :signed_in_user

    def show
      @user = User.find_by(user_name: params[:user_name])
      if @user
        if current_user?(@user) || current_user.is_friend?(@user)
          @events = User.find_by(user_name: params[:user_name]).events.order('created_at DESC')
        else
          @events = User.find_by(user_name: params[:user_name]).events.where("isprivate = 0").order('created_at DESC')
        end
      else
        redirect_to root_path
      end
    end

    def edit
      @user = User.find_by(user_name: params[:user_name])
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