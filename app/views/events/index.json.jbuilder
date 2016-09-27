json.(@events, :language)

json.array! @events do |event|
  json.last_updated @events.order('event_created_at DESC').first
end
