class User <ActiveRecord::Base
  has_many :attendee_lists
  has_many :events, through: :attendee_lists
end
  