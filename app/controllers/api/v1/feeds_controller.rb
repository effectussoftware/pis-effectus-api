 include Pagy::Backend

class Feed
  attr_reader :type, :text, :title

  def self.from_communication(communication)
    new(title: communication.title, text: communication.text, type: 'communication')
  end

  def initialize(args)
    @title = args[:title]
    @text = args[:text]
    @type = args[:type]
  end
end
module Api
  module V1
    class FeedsController < Api::V1::ApiController
      def index
        communications = Communication.where(published: true).order(updated_at: :desc)
        @feeds = communications.map do |communication| 
          Feed.from_communication(communication)
        end
        @pagy, @records = pagy_array(@feeds)
        pagy_headers_merge(@pagy)
      end
    end
  end
end
