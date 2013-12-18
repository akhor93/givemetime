module CalendarHelper
	def day_start(time)
		#.rfc3339 for DateTime is equivalent to strftime('%FT%T%:z')
		time.beginning_of_day.strftime('%FT%T%:z')
	end

	def day_end(time)
		#.rfc3339 for DateTime is equivalent to strftime('%FT%T%:z')
		time.end_of_day.strftime('%FT%T%:z')
	end

	def get_next_time_slot(event_duration = 5)
		current_time = Time.zone.now
		puts current_user.events.size
		counter = 1
    current_user.events.each do |event|
    	puts counter.to_s
      puts event.inspect
      #check if event is in the past
      if current_time > event.start + event.duration.minutes
      	counter = counter + 1
      	next
      end
      #User is currently in an event
      if current_time >= event.start && current_time <= event.start + event.duration.minutes
      	current_time = event.start + event.duration.minutes
      	counter = counter + 1
      	next
      end
      #Event is in future (but by how much)
      if current_time + event_duration.minutes <= event.start
      	break
      else
      	current_time = event.start + event.duration.minutes
      end
      counter = counter + 1
    end
		current_time
	end
end
