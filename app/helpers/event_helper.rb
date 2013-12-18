module EventHelper
	def submit_event(event)
		google_event = {
			'summary' => event.title,
			'location' => 'Some Location',
			'start' => {
				'dateTime' => event.start
			},
			'end' => {
				'dateTime' => event.start + event.duration.to_i.minutes
			}
		}

		result = api_client.execute(:api_method => calendar_api.events.insert,
										:parameters => {'calendarId' => 'primary'},
										:body => JSON.dump(google_event),
										:headers => {'Content-Type' => 'application/json'},
										:authorization => user_credentials)
	end

	def round_up_qh(time = Time.zone.now)
		Time.at((time.to_f / 15.minutes).round * 15.minutes)
	end

	def round_down_qh(time = Time.zone.now)
		Time.at((time.to_f / 15.minutes).floor * 15.minutes)
	end

	def clean_events(google_ids)
		current_time = Time.zone.now
		current_user.events.each do |event|
			if dates_match(current_time, event.start)
				unless google_ids.include? event.google_etag
					puts "destroying event: " + event.inspect
					event.destroy
				end
			end
		end
	end

	def dates_match(time1, time2)
		if time1.day == time2.day && time1.month == time2.month && time1.year == time2.year
			true
		else
			false
		end
	end
end
