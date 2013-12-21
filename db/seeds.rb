# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
andrew = User.new
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