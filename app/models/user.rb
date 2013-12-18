class User < ActiveRecord::Base
	attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :uid, :g_email, :access_token, :refresh_token, :expires_in, :issued_at
	
	attr_accessor :password

	before_save :encrypt_password

	before_validation :prep_email

	has_many :todos, dependent: :destroy
	# has_many :todos, -> { dependent: :destroy}

	has_many :events, dependent: :destroy
	# has_many :events, -> { dependent: :destroy}

	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :password, confirmation: true
	validates :email, uniqueness: true, :email_format => {:message => 'ill-formed email'}

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
