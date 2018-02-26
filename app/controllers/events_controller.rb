class EventsController < ApplicationController
  
  before_action :load_current_user
  
  def index
    @events = Event.all
    render json: @events
  end
  
end
