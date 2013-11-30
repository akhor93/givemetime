module EventHelper
	def submit_event(event)
		google_event = {
			'summary' => event.title,
			'location' => 'Some Location',
			'start' => {
				'dateTime' => DateTime.now.rfc3339
			},
			'end' => {
				'dateTime' => (DateTime.now + event.duration.to_i.minutes).rfc3339
			}
		}

		result = api_client.execute(:api_method => calendar_api.events.insert,
										:parameters => {'calendarId' => 'primary'},
										:body => JSON.dump(google_event),
										:headers => {'Content-Type' => 'application/json'},
										:authorization => user_credentials)
	end

	def round_up_qh(time = Time.now)
		Time.at((time.to_f / 15.minutes).round * 15.minutes)
	end

	def round_down_qh(time = Time.now)
		Time.at((time.to_f / 15.minutes).floor * 15.minutes)
	end
end
