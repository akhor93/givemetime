ActionMailer::Base.smtp_settings = {
	:address => "smtp.gmail.com",
	:port => 587,
	:domain => "givemetime.herokuapp.com",
	:user_name => "givemetimeapp",
	:password => "givemetimesecret",
	:authentication => "plain",
	:enable_starttls_auto => true
}