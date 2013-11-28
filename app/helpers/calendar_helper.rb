module CalendarHelper
	def day_start(day)
		day.beginning_of_day.rfc3339
	end

	def day_end(day)
		day.end_of_day.rfc3339
	end

	def test
		'string'
	end
end
