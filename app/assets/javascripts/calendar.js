$(document).ready(function() {
	if(typeof user_base_time == 'undefined') user_base_time = '-08:00';
	$('.todo_duration_button').click(update_duration);
	$('.activity_duration_button').click(update_duration);
	$('.event_duration_button').click(update_duration);

	update_current_time_bar_position();

	event_tracking();

	var current_time_bar_scroll_top = parseInt($('#current_time_bar').css('top'), 10);
	$('#calendar').scrollTop(current_time_bar_scroll_top - 100);

	$('#calendar').perfectScrollbar({
		wheelSpeed: 150,
		minScrollbarLength: 200
	});

	$('.collapse').on('show.bs.collapse hide.bs.collapse', function() {
		var i = $(this).parent().find('.glyphicon');
		i.toggleClass('glyphicon-chevron-down glyphicon-chevron-right');
	});

	//Set increment
	$('#todo_container').on('prepend_todo',function() {$('#todo_count_badge').html(parseInt($('#todo_count_badge').html(), 10) +1);});

	//Set increment for activity badge
	$('#activity_container').on('prepend_activity',function() {$('#activity_count_badge').html(parseInt($('#activity_count_badge').html(), 10) +1);});

	load_google_events();
});

//Objects
function Cal_Event(title, duration, start) {
		var start_moment = moment(start, "YYYY-MM-DD HH:mm:ss Z").zone(user_base_time);
		var end_moment = moment(start_moment);
		end_moment.add("seconds", parseInt(duration,10));

		this.title = title;
		this.duration = duration;
		this.start = start_moment;
		this.end = end_moment;
		//Decompose following three lines later
		this.inPast = moment().zone(user_base_time) > this.end;
		this.inFuture = moment().zone(user_base_time) < this.start;
		this.isHappening = !this.inPast && !this.inFuture
	}

//Functions
function update_current_time_bar_position() {
	var now = moment().zone(user_base_time);
	var now_end = moment(now).zone(user_base_time).endOf('minute');
	var block_duration = 5;
	var block_height = 25;
	var num_blocks = (now.hours() * 60 + now.minutes()) / block_duration;
	var top_offset = num_blocks * block_height;
	$('#current_time_bar').css('top',top_offset);
}

function update_duration() {
	var $this = $(this);
	//Clear existing active
	$('.' + $this.data('category') + '_duration_button').removeClass('active');
	//Add 'Active' class to button 
	if (!$this.hasClass('active')) {
		$this.addClass('active');
	}
	//Assign Value to hidden field elem
	$('#' + $this.data('category') + '_duration').val($.trim($this.text()));
}

function event_tracking() {
	this.events_list = new Array();
	this.future_events = new Array(); //Includes currently happening events

	$('#event_container').on('append_event', function( event, title, duration, start) {
		var event = new Cal_Event(title, duration, start);
		events_list.push(event);
		if(!event.inPast) future_events.push(event);
		//earliest events are at end of array. This is to use pop over shift
		future_events.sort(sort_events_reverse_chrono_end);
	});	
	
	var millisTillNextMin = moment().zone(user_base_time).endOf('minute'); - moment().zone(user_base_time);
	setTimeout(move_current_time_bar(true),millisTillNextMin);
}

function updateRowIndicies(table_id) {
	//0 for the header row
	var count = 0;
	$('#' + table_id + ' tr').each(function() {
		$(this).find('.index_cell').html(count);
		count += 1;
	});
}

function decrementBadge(badge_id) {
	$('#' + badge_id).html(parseInt($('#' + badge_id).html(), 10) -1);
}

function move_current_time_bar(first) {
	first = typeof first !== 'undefined' ? first : false;
	if(first) {
		$('#current_time_bar').css('top',"-=5");
	}
	if(self.future_events.length > 0) {
		//need to guarantee the end of the first event is before the start of the second
		if(moment().zone(user_base_time) > self.future_events[self.future_events.length-1].end) {
			if(self.future_events.length > 1) {
				//Check if space between next event is more than 5 minutes. Need to account for time
				//user takes to respond and add an event. A strict 5 minutes wont work.
				if(self.future_events[self.future_events.length-2].start > self.future_events[self.future_events.length-1].end.add('minutes',5)) {
					//Enough space, show alert
					alert("You have some free time. Why don't you complete some activities or to-dos");
					update_current_time_bar_position();
				}
				else {
					//Not Enough space between events. Keep for readability
				}
			}
			else {
				//Only event, so send alert
				alert("You have some free time. Why don't you complete some activities or to-dos");
				update_current_time_bar_position();
			}
			self.future_events[self.future_events.length-1].isPast = true;
			self.future_events[self.future_events.length-1].isFuture = false;
			self.future_events[self.future_events.length-1].isHappening = false;
			self.future_events.pop();
		}
		else {
			//Closest event to completion has not finished
		}
	}

	$('#current_time_bar').css('top',"+=5");
	setTimeout(move_current_time_bar, 60000);
}

//Ajax Functions
function load_google_events() {
	$.ajax('/load_google_events');
}

//Utility
function sort_events_chrono_start(a,b) {
	return (a.start - b.start);
}

function sort_events_reverse_chrono_start(a,b) {
	return (b.start - a.start);
}

function sort_events_chrono_end(a,b) {
	return (a.end - b.end);
}

function sort_events_reverse_chrono_end(a,b) {
	return (b.end - a.end);
}