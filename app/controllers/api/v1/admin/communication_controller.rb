# frozen_string_literal: true

module Api
  module V1
    module Admin
      class CommunicationController < Api::V1::Admin::AdminApiController
        before_action :set_communication, only: %i[show update destroy]

        def create
          @communication = Communication.create!(communication_params)
        end

        def index
          @communications = Communication.all
        end

        def update
          @communication.update!(communication_params)
        end

        def destroy
          @communication.destroy
        end

        def set_communication
          @communication = Communication.find(params[:id])
        end

        def communication_params
          params.require(:communication).permit(:title, :text, :published)
        end
      end
    end
  end
end
