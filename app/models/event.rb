class Event < ActiveRecord::Base
  has_many :attendee_lists
  has_many :users, through: :attendee_lists
end