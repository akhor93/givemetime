class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :admin
      t.string :email
      t.string :password_salt
      t.string :password_digest
      t.string :g_email
      t.string :access_token
      t.string :refresh_token
      t.integer :expires_in
      t.timestamp :issued_at
      t.boolean :confirmed
      t.string :time_zone, default: 'Pacific Time (US & Canada)'
      t.string :auth_token
      t.string :password_reset_token
      t.timestamp :password_reset_sent_at
      t.timestamp :time_created

      t.timestamps
    end
  end
end
