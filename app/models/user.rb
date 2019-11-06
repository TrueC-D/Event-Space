class User <ActiveRecord::Base
  has_many :events
  has_many :attendee_lists, through: :events #should be changed to attendees
  # has_many :attendee_lists
  # has_many :events, through: :attendee_lists
  
  def slug
    self.username.downcase.gsub(" ", "-")
  end
  
  def self.find_by_slug(slug)
    self.all.find{|user| user.slug == slug}
  end
  
end
  