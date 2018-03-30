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
      if @event.is_user_attending(@current_user) 
        @event.users.delete(@current_user)
        @event.update({attendees: @event.attendees - 1})
      else
        @event.users << @current_user
        @event.update({ attendees: @event.attendees + 1 })
      end
      render 'events/show'
    else
      not_found
    end
  end
end
