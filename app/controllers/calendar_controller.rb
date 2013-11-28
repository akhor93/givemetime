require 'open-uri'
require 'json'

class CalendarController < ApplicationController
  before_filter :require_login, :only => :index
	def index
    unless user_credentials.access_token || request.path_info =~ /\A\/oauth2/
      redirect_to('/oauth2authorize')
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
    

    # puts @result.data.items[1]['status']
    # result_json = @result.data.to_json
    # result_hash = JSON.parse result_json
    # puts result_hash
    # puts result_hash.class
    # @events = []
    # @result.data.items.each do |item|
    #   event = Event.new(item)
    #   @events.push(event)
    # end
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
    current_user.save

    redirect_to('/calendar')
  end
end
