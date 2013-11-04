class LoadData < ActiveRecord::Migration
  def up
  	andrew = User.new
  	andrew.first_name = "Andrew"
  	andrew.last_name = "Khor"
  	andrew.admin = true
  	andrew.email = "akhor93@stanford.edu"
  	andrew.email_confirmed = "akhor93@stanford.edu"
  	andrew.password = "gloving"
  	andrew.password_salt = SecureRandom.hex
  	andrew.confirmed = true
  	andrew.time_created = Time.now
  	andrew.save
  end

  def down
  	User.destroy_all
  end
end
