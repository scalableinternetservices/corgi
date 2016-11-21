class SessionsController < ApplicationController
	def new
		expires_in 5.hour, :public => true
	end

	def create
		user = User.find_by(user_name: params[:session][:user_name].downcase)
		if user && user.authenticate(params[:session][:password])
			sign_in user
			params[:session][:remember_me] == '1' ? remember(user) : forget(user)
			redirect_back_or '/'
		else 
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'
		end
	end

	def destroy
		sign_out if signed_in?
		redirect_to root_url
	end

	private 
	def session_params
		params.require(:session).permit(:email, :password)
	end

end
