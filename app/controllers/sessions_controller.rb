class SessionsController < ApplicationController
	def new
	end

	def create		
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password]) && (not user.archived?)
			flash[:success] = 'You are signed in!'
			sign_in user
      #redirect_to user_url
			redirect_back_or time_entries_url
		else
			flash.now[:error] = 'Invalid information. Please check your username and password.'
			render 'new'
		end		
	end

	def destroy
		flash[:success] = 'You have successfully signed-out'
		sign_out
		redirect_to root_url
	end
end
