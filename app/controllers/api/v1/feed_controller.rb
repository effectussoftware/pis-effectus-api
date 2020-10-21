# frozen_string_literal: true

module Api
  module V1
    class FeedController < Api::V1::ApiController
      def index
        start = params[:start] ? Time.parse(params[:start]) : Time.zone.now
        with_include = params[:include] || false
        communications = communication_not_recurrent(start, with_include)
        communications += communication_recurrent(start, with_include)
        communications = communications.sort_by(&:updated_at).reverse[0..9]
        @feeds = create_feed(communications)
      end

      private

      def communication_recurrent(start_time, with_include)
        Communication
          .select('id,title,text,recurrent_on AS updated_at')
          .recurrent_from_date(start_time, with_include).order(updated_at: :desc).limit(10)
      end

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
