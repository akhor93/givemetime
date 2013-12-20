$(document).ready(function() {
	$('.event_duration_button').click(update_duration);
	$('.todo_duration_button').click(update_duration);

	var events_list = new Array();
	var future_events = new Array(); //Includes currently happening events
	var alert_queue = new Array();
	

	$('#event_container').on('append_event', function( event, title, duration, start) {
		var event = new Cal_Event(title, duration, start);
		events_list.push(event);
		if(!event.inPast) future_events.push(event);
		//earliest events are at end of array. This is to use pop over shift
		future_events.sort(sort_events_reverse_chrono_start);
	});

	var now = moment();
	var now_end = moment(now).endOf('minute');
	var block_duration = 5;
	var block_height = 25;
	var num_blocks = (now.hours() * 60 + now.minutes()) / block_duration;
	var top_offset = num_blocks * block_height;
	$('#current_time_bar').css('top',top_offset);

	
	var first = true;
	var millisTillNextMin = now_end - now;
	setTimeout(function moveCurrentTimeBar() {
		if(first) {
			$('#current_time_bar').css('top',"-=5");
			first = false;
		}

		// console.log(future_events.length);
		if(future_events.length > 0) {
			// console.log('1');
			//need to guarantee the end of the first event is before the start of the second
			// console.log(moment());
			// console.log(future_events[future_events.length-1].end);
			if(moment() > future_events[future_events.length-1].end) {
				// console.log('2');
				if(future_events.length > 1) {
					// console.log('4*');
					//Check if space between next event is more than 5 minutes. Need to account for time
					//user takes to respond and add an event. A strict 5 minutes wont work.
					if(future_events[future_events.length-2].start > future_events[future_events.length-1].end.add('minutes',5)) {
						// console.log('5');
						//Enough space, show alert
						alert("You have some free time. Why don't you complete some activities or to-dos");
					}
					else {
						// console.log('6');
						//Not Enough space between events. Keep for readability
					}
				}
				else {
					// console.log('3');
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
	$('#calendar').scrollTop(current_time_bar_scroll_top - 100);

	$('#calendar').perfectScrollbar({
		wheelSpeed: 150,
		minScrollbarLength: 200
	});


	$('#load_google_events').click();

	$('.collapse').on('show.bs.collapse hide.bs.collapse', function() {
		var i = $(this).parent().find('.glyphicon');
		i.toggleClass('glyphicon-chevron-down glyphicon-chevron-right');
	});

	$('#todo_container').on('prepend_todo',function() {$('#todo_count_badge').html(parseInt($('#todo_count_badge').html(), 10) +1);});

});

//Objects
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
	}

//Functions
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

//Utility
function sort_events_chrono_start(a,b) {
	return (a.start - b.start);
}

function sort_events_reverse_chrono_start(a,b) {
	return (b.start - a.start);
}