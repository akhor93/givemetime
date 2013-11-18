class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, {:primary_key => :id} do |t|
      t.integer :id
      t.string :first_name
      t.string :last_name
      t.boolean :admin
      t.string :email
      t.string :password_salt
      t.string :password_digest
      t.boolean :confirmed
      t.timestamp :time_created

      t.timestamps
    end
  end
end
