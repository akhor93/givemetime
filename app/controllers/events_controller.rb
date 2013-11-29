class EventsController < ApplicationController
	def create
		event = Event.new(params[:event])
		if event.valid?
			puts DateTime.now + event.duration.to_i.minutes
			#Creating event
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

			@id = result.data.id
		else
			puts event.errors.full_messages.first
		end
		
	end

	def destroy

	end
end
