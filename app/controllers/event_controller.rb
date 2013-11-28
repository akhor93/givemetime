class EventController < ApplicationController
	def create
		#Creating test event
		event = {
			'summary' => 'Party',
			'location' => 'Andrew\'s pants...created by Andrew\'s app',
			'start' => {
				'dateTime' => DateTime.now.rfc3339
			},
			'end' => {
				'dateTime' => (DateTime.now + 1.hour).rfc3339
			}
		}

		result = api_client.execute(:api_method => calendar_api.events.insert,
									:parameters => {'calendarId' => 'primary'},
									:body => JSON.dump(event),
									:headers => {'Content-Type' => 'application/json'},
									:authorization => user_credentials)

		@id = result.data.id

	end
end
