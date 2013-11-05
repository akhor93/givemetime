class User < ActiveRecord::Base
	before_validation :prep_email

	attr_accessible :admin, :confirmed, :email, :first_name, :id, :last_name, :password, :time_created

	has_secure_password

	validates :email, :uniqueness: true, presence: true, format: { with: /^[\w\.+-]+@([\w]+\.)+\w+$/ }
	validates :name, presence: true

	private

	def prep_email
		self.email = self.email.strip.downcase if self.email
	end
end
