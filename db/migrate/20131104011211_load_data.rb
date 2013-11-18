class LoadData < ActiveRecord::Migration
  def up
  	andrew = User.new
    andrew.id = 0;
  	andrew.first_name = "Andrew"
  	andrew.last_name = "Khor"
  	andrew.admin = true
  	andrew.email = "akhor93@gmail.com"
    password = "gloving"
  	andrew.password_salt = BCrypt::Engine.generate_salt
    andrew.password_digest = BCrypt::Engine.hash_secret(password, andrew.password_salt)
  	andrew.confirmed = true
  	andrew.time_created = Time.now
  	if andrew.save
      puts "Andrew saved"
    else
      puts andrew.errors.full_messages
    end
  end

  def down
  	User.destroy_all
  end
end
