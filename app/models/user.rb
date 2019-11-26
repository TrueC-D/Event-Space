class User <ActiveRecord::Base
  has_secure_password
  has_many :events
  has_many :event_attendees
  # has_many :events_attending, through: :event_attendees, source: :event
  # This polymorphic association works better than the events_attending method and works with the views page (but I would have to change other edit and delete methods to not break things)
  
  def events_attending
    EventAttendee.all.select{|item| item.user == self}.collect{|item| item.event}
  end
  
  def attendees
    self.events.collect{|event| event.users}
  end
    
  
  def slug
    self.username.downcase.gsub(" ", "-")
  end
  
  def self.find_by_slug(slug)
    self.all.find{|user| user.slug == slug}
  end
  
end
  