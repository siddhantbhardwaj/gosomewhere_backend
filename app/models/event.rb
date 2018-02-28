class Event < ApplicationRecord
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  
  ## CALLBACKS ##
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  
  ## VALIDATIONS ##
  validates :title, :description, :start_at, :end_at, presence: true
  validates :src_id, uniqueness: true
  
  def self.sync_facebook_events
    url = 'https://go-somewhere-fb.herokuapp.com/events?lat=44.636585&lng=-63.5938442&distance=1000&sort=venue&accessToken='+ENV['FB_ACCESS_TOKEN']
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
          longitude: event['place']['location']['longitude']
        }
        if @event.save
          puts @event.title
        else
          puts "--------------------------------------------------------------------------"
        end
      end
    end
  end
  
  def self.sync_eventbrite_events
    url = 'https://www.eventbriteapi.com/v3/events/search?location.latitude=44.636585&location.longitude=-63.5938442&location.within=1000km&token='+ENV['EVENTBRITE_TOKEN']
    res = RestClient.get(url)
    response = JSON.parse(res)
    response["events"].each do |event|
      @event = Event.find_or_initialize_by(src_id: event["id"])
      @event.attributes = {
        title: event['name']['text'],
        description: event['description']['text'],
        start_at: event['start']["utc"],
        end_at: event['end']["utc"],
      }
      @event.save
    end
  end
  
  private
  def self.fetch_events
    sync_facebook_events
  end
end
