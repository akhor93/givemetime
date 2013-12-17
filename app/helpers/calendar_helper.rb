module CalendarHelper
	def day_start(day)
		day.beginning_of_day.rfc3339
	end

	def day_end(day)
		day.end_of_day.rfc3339
	end

	def get_next_time_slot(event_duration = 5)
		current_time = Time.now
		puts "START TIME: " + current_time.to_s
		puts current_user.events.size
    current_user.events.each do |event|
      puts event.inspect
      #check if event is in the past
      if current_time > event.start + event.duration.minutes
      	next
      end
      #User is currently in an event
      if current_time >= event.start && current_time <= event.start + event.duration.minutes
      	current_time = event.start + event.duration.minutes
      	next
      end
      #Event is in future (but by how much)
      if current_time + event_duration.minutes <= event.start
      	break
      else
      	current_time = event.start + event.duration.minutes
      end
    end
    puts "NEXT FIT: " + current_time.to_s

    "N/A"
	end
end
