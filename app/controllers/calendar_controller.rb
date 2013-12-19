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

    @day = Day.new(Time.zone.now)
    day_start = day_start(@day.time)
    day_end = day_end(@day.time)

    @result = api_client.execute(:api_method => calendar_api.events.list,
                              :parameters => {
                                'calendarId' => 'primary',
                                'timeMin' => day_start,
                                'timeMax' => day_end,
                                'singleEvents' => true
                                },
                              :headers => {'Content-Type' => 'application/json'},
                              :authorization => user_credentials)
    
    current_time = Time.zone.now
    google_ids = Set.new
    @result.data.items.each do |item|
      google_ids.add(item['etag'])
      event = Event.find_by google_etag: item['etag']
      if event.nil?
        event_params = Hash.new
        event_params['title'] = item['summary']
        event_params['duration'] = (item['end']['dateTime'] - item['start']['dateTime']).to_i / 60
        event_params['google_etag'] = item['etag']
        start = item['start']['dateTime']
        start = start.change(:year => current_time.year, :month => current_time.month, :day => current_time.day)
        event_params['start'] = start
        event = Event.new(event_params)
        event.user_id = current_user.id
        event.allocated = true
        if event.save
          puts "event saved"
        else
          puts event.errors.full_messages.first
        end
      end
    end
    # puts "Google ID Set:"
    # puts google_ids.inspect
    # get_next_time_slot(15)
    clean_events(google_ids)
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
