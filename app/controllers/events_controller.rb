class EventsController < ApplicationController
	before_filter :require_login

	def create
		event = Event.new(params[:event])
		#Update the following line later
		event.start = Time.now
		if event.valid?
			result = submit_event(event)
			event.google_etag = result.data['etag']
			event.user_id = current_user.id
			event.allocated = true
			unless event.save
				puts event.errors.full_messages.first
			end
			@event = result.data
		else
			puts event.errors.full_messages.first
		end
	end

	def destroy

	end
end
