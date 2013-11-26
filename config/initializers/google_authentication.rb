require 'google/api_client/client_secrets'

Rails.application.config.before_initialize do
	client = Google::APIClient.new(
      :application_name => 'GiveMeTime',
      :application_version => '0.0.1')

	client_secrets = Google::APIClient::ClientSecrets.load(Rails.root.join('config', 'client_secrets.json'))
    client.authorization = client_secrets.to_authorization
    client.authorization.scope = 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar'

    calendar = client.discovered_api('calendar', 'v3')

    $google_api_client = client
    $google_calendar_api = calendar

    puts "Google Authentication Configured"
end