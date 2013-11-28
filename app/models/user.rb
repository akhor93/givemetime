class User < ActiveRecord::Base
	attr_accessible :first_name, :last_name, :uid, :g_email, :access_token, :refresh_token, :expires_in, :issued_at
	
	before_validation :prep_email

	attr_accessor :password

	before_save :encrypt_password

	validates_presence_of :first_name
	validates_presence_of :last_name
	validates_confirmation_of :password
	#validates :email, uniqueness:true, presence:true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }
	validates :email, :email_format => {:message => 'ill-formed email'}

	def full_name
		"#{first_name} #{last_name}"
	end

	private

	def self.authenticate(email,password)
		user = find_by_email(email)
		if user && user.password_digest == BCrypt::Engine.hash_secret(password, user.password_salt)
			user
		else
			nil
		end
	end

	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_digest = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end

	def prep_email
		self.email = self.email.strip.downcase if self.email
	end
end
