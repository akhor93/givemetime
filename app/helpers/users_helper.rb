module UsersHelper
	def require_admin
		unless logged_in? && current_user.admin
			redirect_to root_url
		end
	end
end
