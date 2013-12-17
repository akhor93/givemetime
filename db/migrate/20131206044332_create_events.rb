class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
    	t.belongs_to :user
    	t.string :title
    	t.timestamp :start
    	t.integer :duration
    	t.string :google_etag
    	t.boolean :allocated, default: false
    	t.timestamps
    end
  end
end
