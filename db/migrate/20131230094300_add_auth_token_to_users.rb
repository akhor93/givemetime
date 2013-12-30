class AddAuthTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_token, :string
    User.all.each do |u|
    	begin
    		u.update_attribute(:auth_token, SecureRandom.urlsafe_base64)
    	end while User.exists?(:auth_token => self[:auth_token])
    end
  end
end
