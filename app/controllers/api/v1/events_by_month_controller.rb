# frozen_string_literal: true

module Api
  module V1
    class EventsByMonthController < Api::V1::ApiController
      def index
        date = params[:date] ? Time.zone.parse(params[:date]) : Time.zone.now
        @events = Event.on_month(date, current_api_v1_user)
        @calendar = events_to_calendar_view(@events)
        raise ActiveRecord::RecordNotFound, 'not found' unless @events
      end

      private

      def events_to_calendar_view(events)
        calendar = Hash.new { |hsh, key| hsh[key] = [] }
        events.map { |event| calendar[event.start_time.strftime('%Y-%m-%d')].push(event_to_array(event)) }
        calendar
      end

      def event_to_array(event)
        # TODO: need to change this
        { id: event.id, name: event.name, address: event.address, start_time: event.start_time,
          end_time: event.end_time, cancelled: event.cancelled, updated_event_at: event.updated_event_at }
      end
    end
  end
end
