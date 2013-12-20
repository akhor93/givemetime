class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
    	t.belongs_to :user
    	t.string :title
    	t.integer :duration
      t.timestamps
    end
  end
end
