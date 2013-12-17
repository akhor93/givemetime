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

	var currentdate = new Date();
	var block_duration = 5;
	var block_height = 25;
	var num_blocks = (currentdate.getHours() * 60 + currentdate.getMinutes()) / block_duration;
	var top_offset = num_blocks * block_height;
	$('#current_time_bar').css('top',top_offset);

	$('#current_time_bar').css('top',"-=5");
	(function moveCurrentTimeBar() {
		$('#current_time_bar').css('top',"+=5");
		setTimeout(moveCurrentTimeBar, 60000);
	})();

	var current_time_bar_scroll_top = parseInt($('#current_time_bar').css('top'), 10);
	$('#calendar').scrollTop(current_time_bar_scroll_top);
});