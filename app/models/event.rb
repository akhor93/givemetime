class Event
	include ActiveModel::Validations

	#attr_accessor :id, :html_link, :title, :start_time, :start_time_zone, :end_time, :end_time_zone
	attr_accessor :title, :duration

	validates :title, presence: true
	validates :duration, presence: true

	def initialize(attributes = {})
		self.title = attributes[:title] if attributes.has_key?(:title)
		self.duration = attributes[:duration] if attributes.has_key?(:duration)
	end
end