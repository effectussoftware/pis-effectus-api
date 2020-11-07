# frozen_string_literal: true

json.events do
  json.array!(@events) do |event|
    json.extract! event, :id, :name, :description, :address, :start_time, :end_time, :updated_event_at, :cancelled
  end
end
