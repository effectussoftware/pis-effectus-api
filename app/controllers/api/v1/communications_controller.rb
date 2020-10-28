# frozen_string_literal: true

module Api
  module V1
    class CommunicationsController < Api::V1::ApiController
      before_action :set_communication, only: %i[show]

      private

      def set_communication
        @communication = Communication.published.find(params[:id])
      end
    end
  end
end