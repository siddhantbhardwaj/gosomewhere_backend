class EventsController < ApplicationController
  
  before_action :load_current_user
  
  def index
    @events = Event.where("end_at > ?", Time.zone.now)
    render 'events/index'
  end
  
  def show
    @event = Event.find_by(id: params[:id])
    if @event
      render 'events/show'
    else
      not_found
    end
  end
end
