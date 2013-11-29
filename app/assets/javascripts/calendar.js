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
});