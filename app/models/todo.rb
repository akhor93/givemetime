class Todo < ActiveRecord::Base
	attr_accessible :title, :duration

	belongs_to :user

	validates :title, presence: true
	validates :duration, presence: true
end
