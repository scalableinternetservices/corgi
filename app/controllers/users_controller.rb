class UsersController < ApplicationController
	before_action :signed_in_user, only: [:show, :edit, :update]
	before_action :correct_user, only: [:edit, :update]

	def new
		@user = User.new
	end

	def index
		@users = User.all
	end
	
	def show
    	@user = User.find(params[:id])
    	#@events = @user.events.paginate(page: params[:page])
    	if @user.isfriend?(current_user)
    		@events = @user.events.paginate(page: params[:page])
    	else
    		@events = @user.events.where("isprivate = 0").paginate(page: params[:page])
    	end
  	end

	def create
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to UCLAevents!"
			redirect_to @user
		else 
			render 'new'
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

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update(user_params)
			flash[:success] = "Profile change successfully"
			redirect_to @user
		else
			render 'edit'
		end
	end

	private
	  	def user_params
	    	params.require(:user).permit(:name, :user_name, :email, :password,
	                                   :password_confirmation)
	  	end

	  	# Confirms the correct user.
	    def correct_user
	      @user = User.find(params[:id])
	      redirect_to root_url unless current_user?(@user)
	    end
end
