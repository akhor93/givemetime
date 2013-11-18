OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
	provider :google_oauth2, '142889764326-hvt1ba1us5fslo0dlpc19fa9vulrigmi.apps.googleusercontent.com', 'JdUfe9hBg1OafxvPUu2mFliy', {
		access_type: 'offline',
		scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar',
		redirect_uri: 'http://localhost/auth/google_oath2/callback'
	}
	
end