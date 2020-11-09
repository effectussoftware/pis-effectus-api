# frozen_string_literal: true

module Api
  module V1
    class EventsCalendarController < Api::V1::ApiController
      def show
        date = params[:id] ? Time.zone.strptime(params[:id], '%Y-%m') : Time.zone.now
        @events = Event.on_month(date, current_api_v1_user).includes(:invitations)
      end
    end
  end
end
