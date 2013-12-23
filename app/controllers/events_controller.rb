class EventsController < ApplicationController
	before_filter :require_login

	def create
		event = Event.new(params[:event])
		event.start = get_next_time_slot(event.duration).utc
		if event.valid?
			result = submit_event(event)
			event.google_etag = result.data['etag']
			event.user_id = current_user.id
			event.allocated = true
			unless event.save
				puts event.errors.full_messages.first
			end
			@event = result.data
			respond_to do |format|
  			format.js { render :locals => { :source => :event } }
			end
		else
			puts event.errors.full_messages.first
		end
	end

	def destroy
		event = current_user.events.find(params[:id])
		unless event.nil?
			@event_id = event.id
			event.destroy
			respond_to do |format|
				format.js {}
			end
		end
	end
end
