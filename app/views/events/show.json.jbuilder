json.partial! 'events/event', event: @event
json.is_attending @event.is_user_attending(@current_user)