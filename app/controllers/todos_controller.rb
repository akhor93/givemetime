class TodosController < ApplicationController
	def create
		@todo = current_user.todos.create(params[:todo])
	end

	def destroy

	end
end
