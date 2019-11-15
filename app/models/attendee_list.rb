class EventAttendee <ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  
  def self.find_by_ids(user_id, event_id)
    @@all.find{|item| item.user_id== user_id && item.event_id == event_id}
  end
end
