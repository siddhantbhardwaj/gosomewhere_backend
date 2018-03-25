json.array!(@events) do |event|
  json.partial! 'events/show', event: event
end