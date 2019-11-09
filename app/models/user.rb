class User <ActiveRecord::Base
  has_many :events
  has_many :event_attendees
  has_many :users, through: :events
  # has_many :users, through: :events, through: :event_attendees
  has_many :events, through: :event_attendees
  
  def slug
    self.username.downcase.gsub(" ", "-")
  end
  
  def self.find_by_slug(slug)
    self.all.find{|user| user.slug == slug}
  end
  
end
  