class Event < ActiveRecord::Base
	default_scope order: 'start DESC'

	attr_accessible :title, :start, :duration, :google_etag, :user_id, :allocated

	validates :title, presence: true
	validates :duration, presence: true
	validates :google_etag, uniqueness: true

	belongs_to :user

	# def initialize(attributes = {})
	# 	puts "initialize"
	# 	self.title = attributes['title'] if attributes.has_key?('title')
	# 	self.duration = attributes['duration'] if attributes.has_key?('duration')
	# 	self.google_etag = attributes['etag'] if attributes.has_key?('etag')
	# end
end