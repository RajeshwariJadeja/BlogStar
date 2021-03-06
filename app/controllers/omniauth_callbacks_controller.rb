class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def all
		
		user = User.from_omniauth(request.env["omniauth.auth"])
		if user.persisted?
			sign_in_and_redirect user, notice:"signed_in!"
		else
			session["devise.user_attributes"]= user.attributes
			redirect_to new_user_registration_path
		end


	end
	alias_method :twitter, :all
	alias_method :facebook, :all
	alias_method :google_oauth2, :all
end
