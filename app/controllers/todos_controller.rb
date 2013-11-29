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
end
