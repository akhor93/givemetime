class TodosController < ApplicationController
	before_filter :require_login

	def create
		@todo = current_user.todos.create(params[:todo])
	end

	def destroy
		todo = current_user.todos.find(params[:id])
		@todo_id = todo.id
		todo.destroy
	end

	def to_event
		todo = current_user.todos.find(params[:id])
		unless todo.nil?
			event = Event.new
			event.title = todo.title
			event.duration = todo.duration
			#Update following line
			event.start = Time.now
			if event.valid?
				result = submit_event(event)
				event.google_etag = result.data['etag']
				event.user_id = current_user.id
				event.allocated = true;
				event.save
				@event = result.data
				respond_to do |format|
  				format.js { render 'events/create' }
				end
			else
				puts event.errors.full_messages.first
			end
		end
	end
end
