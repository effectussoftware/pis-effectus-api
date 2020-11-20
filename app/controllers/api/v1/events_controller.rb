# frozen_string_literal: true

module Api
  module V1
    class EventsController < Api::V1::ApiController
      def index
        date = if params[:filters] && params[:filters][:date]
                 Time.zone.strptime(params[:filters][:date], '%Y-%m')
               else
                 Time.zone.now
               end
        @events = events.on_month(date, current_api_v1_user).includes(:invitations)
      end

      def show
        @event = events.find(params[:id])
        @invitation = @event.invitations.find_by!(user: current_api_v1_user)
        raise ActiveRecord::RecordNotFound, 'No encontrado' unless @invitation
      end

      private

      def events
        Event.published
      end
    end
  end
end
