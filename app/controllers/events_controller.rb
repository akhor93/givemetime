require 'time'

class EventsController < ApplicationController
	before_filter :require_login

	def create
		event = Event.new(params[:event])
		if event.valid?
			result = submit_event(event)
			@event = result.data
		else
			puts event.errors.full_messages.first
		end
		
		
	end

	def destroy

	end
end
