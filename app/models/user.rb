class User < ActiveRecord::Base
	before_validation :prep_email

	attr_accessible :admin, :confirmed, :email, :first_name, :id, :last_name, :password, :password_confirmation, :time_created

	has_secure_password

	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :email, uniqueness: true, presence: true, format: { with: /^[\w\.+-]+@([\w]+\.)+\w+$/ }
	

	private

	def prep_email
		self.email = self.email.strip.downcase if self.email
	end
end
