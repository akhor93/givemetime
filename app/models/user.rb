class User < ActiveRecord::Base
	attr_accessible :first_name, :last_name, :email, :time_zone, :password, :password_confirmation, :uid, :g_email, :access_token, :refresh_token, :expires_in, :issued_at
	
	has_secure_password

	before_validation :prep_email
	before_create { generate_token(:auth_token) }

	has_many :activities, dependent: :destroy

	has_many :todos, dependent: :destroy
	# has_many :todos, -> { dependent: :destroy}

	has_many :events, dependent: :destroy
	# has_many :events, -> { dependent: :destroy}

	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :password, presence: true, :on => :create
	validates :password, confirmation: true
	validates :email, uniqueness: true, :email_format => {:message => 'ill-formed email'}

	def full_name
		"#{first_name} #{last_name}"
	end

	def send_password_reset
		generate_token(:password_reset_token)
		self.password_reset_sent_at = Time.zone.now
		save!
		UserMailer.password_reset(self).deliver
	end

	def prep_email
		self.email = self.email.strip.downcase if self.email
	end

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
	end
end
