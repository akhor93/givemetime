module UsersHelper
	def require_admin
		unless logged_in? && current_user.admin
			redirect_to root_url
		end
	end

	def api_client; Settings[:api_client]; end
	def calendar_api; Settings[:calendar]; end

	def user_credentials
		# Build a per-request oauth credential based on token stored in session
  		# which allows us to use a shared API client.
  		@authorization ||= (
  			auth = api_client.authorization.dup
  			auth.redirect_uri = 'http://localhost:3000/oauth2callback'
  			auth.update_token!(
  				:access_token => session[:access_token],
  				:refresh_token => session[:refresh_token],
  				:expires_in => session[:expires_in],
  				:issued_at => session[:issued_at],
  				:id_token => session[:id_token]
  				)
  			auth
  			)
	end
end
