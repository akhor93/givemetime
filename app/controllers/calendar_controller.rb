require 'open-uri'
require 'json'

class CalendarController < ApplicationController
  before_filter :require_login

  layout 'private'

	def index
    unless user_credentials.access_token || request.path_info =~ /\A\/oauth2/
      redirect_to('/oauth2authorize')
      return
    end

    @day = Day.new(DateTime.now)
    day_start = day_start(@day.datetime)
    day_end = day_end(@day.datetime)

    @result = api_client.execute(:api_method => calendar_api.events.list,
                              :parameters => {
                                'calendarId' => 'primary',
                                'timeMin' => day_start,
                                'timeMax' => day_end
                                },
                              :headers => {'Content-Type' => 'application/json'},
                              :authorization => user_credentials)
  end

  def oauth2authorize
    # Request authorization
    redirect_to user_credentials.authorization_uri.to_s, status: 303
  end

  def oauth2callback
    # Exchange token
    user_credentials.code = params[:code] if params[:code]
    user_credentials.fetch_access_token!

    current_user.access_token ||= user_credentials.access_token;
    current_user.refresh_token ||= user_credentials.refresh_token
    current_user.expires_in ||= user_credentials.expires_in
    current_user.issued_at ||= user_credentials.issued_at
    
    address = 'https://www.googleapis.com/userinfo/email' + '?' + 'access_token=' + current_user.access_token + '&alt=json'
    json_results = open(address).read
    json_object = JSON.parse(json_results)

    current_user.g_email = json_object['data']['email']

    unless current_user.save
      puts current_user.errors.full_messages.first
    end

    redirect_to('/calendar')
  end
end
