class Day
	include ActiveModel::Validations

	attr_accessor :datetime

	

	def initialize(datetime, attributes = {})
		attributes.each do |name, value|
			send("#{name}=", value)
		end
		self.datetime = datetime
	end

	def date
		self.datetime.to_date
	end

	def self.hours(add_meridium = false)
		hours = []
		start_hour = 0
		end_hour = 24
		meridium = 'am'
		while start_hour < end_hour
			if start_hour % 12 == 0
				if add_meridium
					hours.push('12' + meridium)
				else
					hours.push('12')
				end
			else
				if add_meridium
					hours.push((start_hour % 12).to_s + meridium)
				else
					hours.push((start_hour % 12).to_s)
				end
			end

			if start_hour >= 11
				meridium = 'pm'
			end
			start_hour = start_hour + 1
		end
		hours
	end

	#TO-DO Add Meridium option (maybe)
	def self.quarter_hours
		q_hours = []
		hours = Day.hours
		hours.each do |hour|
			q_hours.push(hour + ':00')
			q_hours.push(hour + ':15')
			q_hours.push(hour + ':30')
			q_hours.push(hour + ':45')
		end
		q_hours
	end
end