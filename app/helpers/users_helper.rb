module UsersHelper
	def require_admin
		unless logged_in? && current_user.admin
			redirect_to root_url
		end
	end

	def api_client; $google_api_client; end
	def calendar_api; $google_calendar_api; end

	def user_credentials
		# Build a per-request oauth credential based on token stored in session
  		# which allows us to use a shared API client.
  		@authorization ||= (
  			auth = api_client.authorization.dup
  			auth.redirect_uri = 'http://localhost:3000/oauth2callback'
  			auth.update_token!(
  				:access_token => current_user.access_token,
  				:refresh_token => current_user.refresh_token,
  				:expires_in => current_user.expires_in,
  				:issued_at => current_user.issued_at,
  				)
  			auth
  			)
	end
end
