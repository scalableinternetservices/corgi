class UsersController < ApplicationController
	before_action :signed_in_user, only: [:edit, :update]
	before_action :correct_user, only: [:edit, :update]

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to UCLA events!"
			redirect_to profile_path(@user.user_name)
		else 
			render 'new'
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update(user_params)
			flash[:success] = "Profile change successfully"
			redirect_to profile_path(@user.user_name)
		else
			render 'edit'
		end
	end

	def following
		@title = "Following"
    	@user  = User.find(params[:id])
    	@users = @user.following.paginate(page: params[:page])
    	render 'show_follow'
	end

	def followers
		@title = "Followers"
   		@user  = User.find(params[:id])
    	@users = @user.followers.paginate(page: params[:page])
    	render 'show_follow'
   	end

	private
	  	def user_params
	    	params.require(:user).permit(:name, :user_name, :email, :password, :background, 
	                                   :password_confirmation,:avatar)
	  	end

	  	# Confirms the correct user.
	    def correct_user
	      @user = User.find(params[:id])
	      redirect_to root_url unless current_user?(@user)
	    end
end
