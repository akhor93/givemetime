class Event
	include ActiveModel::Validations

	attr_accessor :id, :html_link, :title, :start_time, :start_time_zone, :end_time, :end_time_zone

	def initialize(item)
		self.id = item['id']
		self.html_link = item['html_link']
		self.title = item['summary']
		# self.start_time = item['start']['dateTime']
		# self.start_time_zone = item['start']['timeZone']
		# self.end_time = item['end']['dateTime']
		# self.end_time_zone = item['end']['timeZone']
	end
end