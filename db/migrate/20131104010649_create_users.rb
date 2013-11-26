class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :admin
      t.string :email
      t.string :password_salt
      t.string :password_digest
      t.string :uid
      t.string :g_email
      t.string :access_token
      t.string :refresh_token
      t.integer :expires_in
      t.timestamp :issued_at
      t.boolean :confirmed
      t.timestamp :time_created

      t.timestamps
    end
  end
end
