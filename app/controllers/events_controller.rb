class EventsController < ApplicationController
  
  before_action :load_current_user
  
  def index
    @events = Event.where("end_at > ?", Time.zone.now)
    render json: @events
  end
  
end
