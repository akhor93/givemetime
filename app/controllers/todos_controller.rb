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
			event = Event.new(todo.attributes)
			if event.valid?
				result = submit_event(event)
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
