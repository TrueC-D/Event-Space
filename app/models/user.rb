class User <ActiveRecord::Base
  has_secure_password
  has_many :events
  has_many :event_attendees
  # has_many :users, through: :events
  # has_many :users, through: :events, through: :event_attendees
  # has_many :events, through: :event_attendees
  
  # def events_attending
  #   event_ids = Event_attendee.all.select{|event| event.user_id == self.id}.each{|event| event.event_id}
  #   event_ids.collect{|event_id| Event.find_by_id{id: :event_id}
  # end
  
  def events_attending
    Event_attendee.all.select{|item| item.user == self}.collect{|item| item.event}
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
  