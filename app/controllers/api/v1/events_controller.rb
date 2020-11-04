# frozen_string_literal: true

module Api
  module V1
    class EventsController < Api::V1::ApiController
      def index
        date = params[:date] ? Time.zone.parse(params[:date]) : Time.zone.now
        @events = Event.on_month(date, current_api_v1_user)
        raise ActiveRecord::RecordNotFound, 'not found' unless @events

        events_to_calendar_view
      end

      def show
        @event = Event.find(params[:id])
        @invitation = @event.invitations.find_by(user: current_api_v1_user)
        raise ActiveRecord::RecordNotFound, 'not found' unless @invitation
      end

      private

      def events_to_calendar_view
        @calendar = Hash.new { |hsh, key| hsh[key] = [] }
        @events.map do |event|
          @calendar[event.start_time.strftime('%Y-%m-%d')].push(event.as_json.except('created_at', 'cost'))
        end
      end
    end
  end
end
