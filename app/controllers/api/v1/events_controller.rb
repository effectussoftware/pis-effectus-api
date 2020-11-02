# frozen_string_literal: true

module Api
  module V1
    class EventsController < Api::V1::ApiController
      def show
        @event = Event.find(params[:id])
        @invitation = @event.invitations.find_by(user: current_api_v1_user)
        raise ActiveRecord::RecordNotFound, 'not found' unless @invitation
      end
    end
  end
end
