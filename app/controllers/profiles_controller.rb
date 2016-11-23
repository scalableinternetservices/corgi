class ProfilesController < ApplicationController  
    before_action :correct_user, only: [:edit, :update]
    before_action :signed_in_user

    def show
      @user = User.includes(:followers,:following).find_by(user_name: params[:user_name])
      # optimization
      # @user = User.includes(:events).find_by(user_name: params[:user_name])
      if @user
        if current_user?(@user) || current_user.is_friend?(@user)
          @events = Event.includes(:guests, :comments, :tags).where(:user_id => @user.id).order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
          # @events = @user.events.order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
        else
          @events = Event.includes(:guests, :comments, :tags).where(:user_id => @user.id, :isprivate => 0).order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
          # @events = @user.events.where(:isprivate => 0).order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
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