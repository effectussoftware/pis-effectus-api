# frozen_string_literal: true
module Api
  module V1
    class FeedsController < Api::V1::ApiController
      def index
        start = params[:start] ? Time.parse(params[:start]) : Time.now
        with_include = params[:include] ? true : false
        communications = communication_not_recurrent(start, with_include)
        communications += communication_recurrent(start, with_include)
        communications = communications.sort_by(&:updated_at).reverse[0..9]
        @feeds = create_feed(communications)
      end

      private

      def communication_recurrent(start_time, with_include)
        query = if with_include
                  '(extract(month from recurrent_on) < ?) OR
          (extract(month from recurrent_on)= ? AND extract(day from recurrent_on) <= ?)'
                else
                  '(extract(month from recurrent_on) < ?) OR
          (extract(month from recurrent_on)= ? AND extract(day from recurrent_on) < ?)'
                end
        Communication
          .select('id,title,text,recurrent_on AS updated_at')
          .where(query, start_time.month, start_time.month, start_time.day).order(updated_at: :desc).limit(10)
      end

      def communication_not_recurrent(start_time, with_include)
        query = if with_include
                  'communications.updated_at <= ? AND
                  communications.published = true AND
                  communications.recurrent_on is NULL'
                else
                  'communications.updated_at < ? AND
                 communications.published = true AND
                 communications.recurrent_on is NULL'
                end
        Communication.where(query, start_time).order(updated_at: :desc).limit(10)
      end

      def create_feed(communications)
        communications.map do |communication|
          Feed.from_communication(communication)
        end
      end
    end
  end
end
