# frozen_string_literal: true

@calendar.each do |key, events|
  json.set! key do
    json.array!(events) do |event|
      json.extract! event, :id, :name, :address, :start_time, :end_time, :updated_event_at, :cancelled
    end
  end
end
