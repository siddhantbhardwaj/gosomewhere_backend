class EventsController < ApplicationController
  
  before_action :load_current_user
  
  def index
    @events = Event.includes(:users).where("end_at > ?", Time.zone.now)
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
  
  def change_attending
    @event = Event.find_by(id: params[:event_id])
    if @event
      @event.is_user_attending(@current_user) ? @event.users.delete(@current_user) : (@event.users << @current_user)
      render 'events/change_attending'
    else
      not_found
    end
  end
end
