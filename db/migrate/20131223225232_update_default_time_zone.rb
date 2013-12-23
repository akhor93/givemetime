class UpdateDefaultTimeZone < ActiveRecord::Migration
  def change
  	change_column :users, :time_zone, :string, :default => 'Pacific Time (US & Canada)'
  	User.update_all({ :time_zone => 'Pacific Time (US & Canada)' }, { :time_zone => 'Central Time (US & Canada)' })
  end
end
