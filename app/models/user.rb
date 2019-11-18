class User <ActiveRecord::Base
  has_secure_password
  has_many :events
  has_many :event_attendees
  
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
  