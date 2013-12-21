class ActivitiesController < ApplicationController
	before_filter :require_login

	def create
		@activity = current_user.activities.create(params[:activity])
		respond_to do |format|
			format.js {}
		end
	end

	def destroy
		activity = current_user.activities.find(params[:id])
		unless activity.nil?
			@activity_id = activity.id
			activity.destroy
			respond_to do |format|
				format.js {}
			end
		end
	end

	def to_event
		activity = current_user.activities.find(params[:id])
		unless activity.nil?
			event = Event.new
			event.title = activity.title
			event.duration = activity.duration
			event.start = get_next_time_slot(event.duration)
			if event.valid?
				#Need to destroy activity
				result = submit_event(event)
				event.google_etag = result.data['etag']
				event.user_id = current_user.id
				event.allocated = true;
				event.save
				@event = result.data
				respond_to do |format|
  				format.js { render 'events/create', :locals => { :source => :activity } }
				end
			else
				puts event.errors.full_messages.first
			end
		end
	end
end
