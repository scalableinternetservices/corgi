class UsersController < ApplicationController
	before_filter :signed_in_user
	# before_filter :correct_user, only: [:edit, :update]
	def new
		@user = User.new
	end

	def show
    	@user = User.find(params[:id])
    	@events = @user.events.paginate(page: params[:page])
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

	private
	  	def user_params
	    	params.require(:user).permit(:name, :email, :password,
	                                   :password_confirmation)
	  	end

	  	# Confirms the correct user.
	    def correct_user
	      @user = User.find(params[:id])
	      redirect_to root_url unless current_user?(@user)
	    end
end
