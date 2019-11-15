class Event < ActiveRecord::Base
  belongs_to :user
  has_many :event_attendees
  has_many :users, through: :event_attendees

  
end