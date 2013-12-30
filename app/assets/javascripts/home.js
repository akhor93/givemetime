$(document).ready(function() {
	var tz = jstz.determine();
	$('#user_time_zone').val(tz.name());
});
