class EventsController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]
  
  def index
    @events = Event.all
    render json: @events
  end
end
