# frozen_string_literal: true

@calendar.each do |key, events|
  json.set! key, events
end
