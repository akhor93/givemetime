class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
    	t.belongs_to :user
      t.string :title
      t.integer :duration
      t.timestamps
    end
  end
end
