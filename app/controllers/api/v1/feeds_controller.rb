# frozen_string_literal: true

class Feed
  attr_reader :id, :type, :text, :title, :updated_at

  def self.from_communication(communication)
    new(id: communication.id,
        title: communication.title,
        text: communication.text,
        type: 'communication',
        updated_at: communication.updated_at)
  end

  def initialize(args)
    @id =  args[:id]
    @title = args[:title]
    @text = args[:text]
    @type = args[:type]
    @updated_at = args[:updated_at]
  end
end
module Api
  module V1
    class FeedsController < Api::V1::ApiController
      def index
        start = params[:start] ? Time.parse(params[:start]) : Time.now
        communications = communication_not_recurrent(start)
        communications += communication_recurrent(start)
        communications = communications.sort_by(&:updated_at).reverse[0..9]
        @feeds = communications.map do |communication|
          Feed.from_communication(communication)
        end
      end

      private

      def communication_recurrent(start_time)
        Communication
          .select('id,title,text,recurrent_on AS updated_at')
          .where('(extract(month from recurrent_on) < ?) OR
                    (extract(month from recurrent_on)= ? AND extract(day from recurrent_on) < ?)',
                 start_time.month, start_time.month, start_time.day)
          .order(updated_at: :desc).limit(10)
      end

      def communication_not_recurrent(start_time)
        Communication
          .where('communications.updated_at < ? AND
                  communications.published = true AND
                  communications.recurrent_on is NULL', start_time)
          .order(updated_at: :desc).limit(10)
      end
    end
  end
end
