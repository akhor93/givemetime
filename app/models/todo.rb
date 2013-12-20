class Todo < ActiveRecord::Base
	default_scope { order('created_at DESC') }
	attr_accessible :title, :duration

	belongs_to :user

	validates :title, presence: true
	validates :duration, presence: true
end
