# frozen_string_literal: true

module Api
  module V1
    class FeedsController < Api::V1::ApiController
      def show
        start = params[:start] ? Time.zone.parse(params[:start]) : Time.zone.now
        with_include = params[:include] || false
        communications = communication_not_recurrent(start, with_include)
        debugger
        @feeds = create_feed(communications)
      end

      private

      def communication_not_recurrent(start_time, with_include)
        Communication.not_recurrent_from_date(start_time, with_include).order(updated_at: :desc).limit(10)
      end

      def create_feed(communications)
        communications.map do |communication|
          Feed.from_communication(communication)
        end
      end
    end
  end
end
