class TodosController < ApplicationController
	before_filter :require_login

	def create
		@todo = current_user.todos.create(params[:todo])
		respond_to do |format|
			format.js {}
		end
	end

	def destroy
		todo = current_user.todos.find(params[:id])
		unless todo.nil?
			@todo_id = todo.id
			todo.destroy
			respond_to do |format|
				format.js {}
			end
		end
	end

	def to_event
		todo = current_user.todos.find(params[:id])
		unless todo.nil?
			todo_id = todo.id
			event = Event.new
			event.title = todo.title
			event.duration = todo.duration
			event.start = get_next_time_slot(event.duration).utc
			if event.valid?
				todo.destroy
				result = submit_event(event)
				event.google_etag = result.data['etag']
				event.user_id = current_user.id
				event.allocated = true;
				unless event.save
					puts event.errors.full_messages.first
				end
				@event = result.data
				@event_id = event.id
				respond_to do |format|
  				format.js { render 'events/create', :locals => { :source => :todo, :id => todo_id} }
				end
			else
				puts event.errors.full_messages.first
			end
		end
	end
end
