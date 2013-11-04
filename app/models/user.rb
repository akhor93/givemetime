class User < ActiveRecord::Base
  attr_accessible :admin, :confirmed, :email, :first_name, :id, :last_name, :password, :time_created
end
