$(document).ready(function() {
	$('.event_duration_button').click(function() {
		//Clear existing active
		$('.event_duration_button').removeClass('active');
		//Add 'Active' class to button 
		var $this = $(this);
		if (!$this.hasClass('active')) {
			$this.addClass('active');
		}
		//Assign Value to hidden field elem
		$('#event_duration').val($.trim($this.text()));
	});

	$('.todo_duration_button').click(function() {
		//Clear existing active
		$('.todo_duration_button').removeClass('active');
		//Add 'Active' class to button 
		var $this = $(this);
		if (!$this.hasClass('active')) {
			$this.addClass('active');
		}
		//Assign Value to hidden field elem
		$('#todo_duration').val($.trim($this.text()));
	});

	var events_list = new Array();
	var future_events = new Array(); //Includes currently happening events
	var alert_queue = new Array();
	function Cal_Event(title, duration, start) {
		var start_moment = moment(start, "YYYY-MM-DD HH:mm:ss Z");
		var end_moment = moment(start_moment);
		end_moment.add("seconds", parseInt(duration,10));

		this.title = title;
		this.duration = duration;
		this.start = start_moment;
		this.end = end_moment;
		//Decompose following three lines later
		this.inPast = moment() > this.end;
		this.inFuture = moment() < this.start;
		this.isHappening = !this.inPast && !this.inFuture
		//console.log(this);
		// console.log(start_moment.hour());
		// console.log(end_moment.hour());
		// var now = moment();
		// this.isPast = now.diff(start + duration)
		// console.log(start);
		
	}

	$('#event_container').on('append_event', function( event, title, duration, start) {
		var event = new Cal_Event(title, duration, start);
		events_list.push(event);
		if(!event.isPast) future_events.push(event);
		//earliest events are at end of array. Allows for pop to work well
		future_events.sort(sort_events_reverse_chrono_start);
		// events_list.sort(sort_events_chrono_start);
		// console.log(events_list);
	});

	function sort_events_chrono_start(a,b) {
		// console.log(a.title + ' ' + b.title);
		var val = (a.start - b.start);
		// console.log(val);
		return val;
	}

	function sort_events_reverse_chrono_start(a,b) {
		return (b.start - a.start);
	}


	var now = moment();
	var now_end = moment(now).endOf('minute');
	var block_duration = 5;
	var block_height = 25;
	var num_blocks = (now.hours() * 60 + now.minutes()) / block_duration;
	var top_offset = num_blocks * block_height;
	$('#current_time_bar').css('top',top_offset);

	
	var first = true;
	var millisTillNextMin = now_end - now;
	console.log(millisTillNextMin);
	setTimeout(function moveCurrentTimeBar() {
		if(first) {
			$('#current_time_bar').css('top',"-=5");
			first = false;
		}

		console.log(future_events.length);
		if(future_events.length > 0) {
			console.log('1');
			//need to guarantee the end of the first event is before the start of the second
			console.log(moment());
			console.log(future_events[future_events.length-1].end);
			if(moment() > future_events[future_events.length-1].end) {
				console.log('2');
				if(future_events.length > 1) {
					console.log('4*');
					//Check if space between next event is more than 5 minutes. Need to account for time
					//user takes to respond and add an event. A strict 5 minutes wont work.
					if(future_events[future_events.length-2].start > future_events[future_events.length-1].end.add('minutes',5)) {
						console.log('5');
						//Enough space, show alert
						alert("You have some free time. Why don't you complete some activities or to-dos");
					}
					else {
						console.log('6');
						//Not Enough space between events. Keep for readability
					}
				}
				else {
					console.log('3');
					//Only event, so send alert
					alert("You have some free time. Why don't you complete some activities or to-dos");
				}
				future_events[future_events.length-1].isPast = true;
				future_events[future_events.length-1].isFuture = false;
				future_events[future_events.length-1].isHappening = false;
				future_events.pop();
			}
			else {
				console.log('not finished');
			}
		}


		$('#current_time_bar').css('top',"+=5");
		setTimeout(moveCurrentTimeBar, 60000);
	},millisTillNextMin);

	var current_time_bar_scroll_top = parseInt($('#current_time_bar').css('top'), 10);
	$('#calendar').scrollTop(current_time_bar_scroll_top);

	$('#calendar').perfectScrollbar({
		wheelSpeed: 100,
		minScrollbarLength: 200
	});


	$('#load_google_events').click();

});