# frozen_string_literal: true

module Api
  module V1
    class PriorityFeedsController < Api::V1::ApiController
      def show
        @feeds = create_feed(events)
      end

      private

      def events
        Event.future.published.joins(:invitations).where(
          'invitations.user_id = ? AND NOT invitations.confirmation AND NOT cancelled', current_user.id
        ).order(
          start_time: :desc
        ).includes(:invitations)
      end

      def create_feed(events)
        events.map do |event|
          Feed.from_event(event, event.invitations.find_by(user: current_api_v1_user))
        end
      end
    end
  end
end
