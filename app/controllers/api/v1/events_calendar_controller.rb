# frozen_string_literal: true

module Api
  module V1
    class EventsCalendarController < Api::V1::ApiController
      def show
        date = params[:id] ? Time.zone.parse(params[:id]) : Time.zone.now
        @events = Event.on_month(date, current_api_v1_user)

        events_to_calendar_view
      end

      private

      def events_to_calendar_view
        @calendar = Hash.new { |hsh, key| hsh[key] = [] }
        @events.map do |event|
          @calendar[event.start_time.strftime('%Y-%m-%d')].push(event)
        end
      end
    end
  end
end
