$(document).ready(function() {
	$('.duration_button').click(function() {
		//Clear existing active
		$('.duration_button').removeClass('active');
		//Add 'Active' class to button 
		var $this = $(this);
		if (!$this.hasClass('active')) {
			$this.addClass('active');
		}
		//Assign Value to hidden field elem
		$('#event_duration').val($.trim($this.text()));
	});
});