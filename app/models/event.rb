class Event < ApplicationRecord
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  
  ## ASSOCIATIONS ##
  has_many :comments
  has_and_belongs_to_many :users
  
  ## CALLBACKS ##
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  after_validation :reverse_geocode, if: ->(obj){ obj.address.blank? and obj.latitude.present? and obj.longitude.present? }
  
  ## VALIDATIONS ##
  validates :title, :description, :start_at, :end_at, presence: true
  validates :src_id, uniqueness: true
  
  def is_user_attending(user)
    users.exists?(user.id)
  end
  
  def self.sync_facebook_events
    url = 'https://go-somewhere-fb.herokuapp.com/events?lat=44.636585&lng=-63.5938442&distance=100&sort=venue&accessToken='+ENV['FB_ACCESS_TOKEN']
    res = RestClient.get(url)
    response = JSON.parse(res)
    if response["events"]
      response["events"].each do |event|
        @event = Event.find_or_initialize_by(src_id: event["id"])
        @event.attributes = {
          title: event['name'],
          description: event['description'],
          start_at: event['startTime'],
          end_at: event['endTime'],
          attendees: event['stats']['attending'],
          latitude: event['place']['location']['latitude'],
          longitude: event['place']['location']['longitude'],
          image: event['coverPicture'],
          source: 'facebook'
        }
        if @event.save
          puts @event.title
        else
          puts "--------------------------------------------------------------------------"
        end
      end
    end
  end
  
  def self.sync_eventbrite_events(url)
    res = RestClient.get(url)
    response = JSON.parse(res)
    response["events"].each do |event|
      @event = Event.find_or_initialize_by(src_id: event["id"])
      @event.attributes = {
        title: event['name']['text'],
        description: event['description']['text'],
        start_at: event['start']["utc"],
        end_at: event['end']["utc"],
        latitude: event['venue']['latitude'],
        longitude: event['venue']['longitude'],
        address: event['venue']['address']['localized_address_display'],
        image: event['logo']['original']['url'],
        source: 'eventbrite'
      }
      @event.save
    end
  end

  def self.sync_eventbrite_events_toronto
    sync_eventbrite_events('https://www.eventbriteapi.com/v3/events/search?location.latitude=43.653908&location.longitude=-79.384293&location.within=200km&expand=venue&token='+ENV['EVENTBRITE_TOKEN'])
  end

  def self.sync_eventbrite_events_halifax
    sync_eventbrite_events('https://www.eventbriteapi.com/v3/events/search?location.latitude=44.651070&location.longitude=-63.582687&location.within=100km&expand=venue&token='+ENV['EVENTBRITE_TOKEN'])
  end
  
  private
  def self.fetch_events
    sync_eventbrite_events_toronto
    sync_eventbrite_events_halifax
    sync_facebook_events
  end
end
