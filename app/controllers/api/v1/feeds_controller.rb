# frozen_string_literal: true

module Api
  module V1
    class FeedsController < Api::V1::ApiController
      def show
        start = params[:start] ? Time.zone.parse(params[:start]) : Time.zone.now
        with_include = params[:include] || false
        communications = communication_not_recurrent(start, with_include)
        reviews = reviews(start, with_include)
        @feeds = create_feed(communications, reviews)
      end

      private

      def reviews(start_time, with_include)
        Review.from_date(start_time, with_include, current_user.id).order(updated_at: :desc).limit(10)
      end

      def communication_not_recurrent(start_time, with_include)
        Communication.not_recurrent_from_date(start_time, with_include).order(updated_at: :desc).limit(10)
      end

      def create_feed(communications, reviews)
        feed = communications.map do |communication|
          Feed.from_communication(communication)
        end

        feed += reviews.map do |review|
          Feed.from_review(review)
        end

        feed.sort_by(&:updated_at).reverse[0..9]
      end
    end
  end
end
