# frozen_string_literal: true

module Api
  module V1
    module Admin
      class CommunicationsController < Api::V1::Admin::AdminApiController
        before_action :set_communication, only: %i[show update destroy]

        def index
          @pagy, @communications = pagy(Communication.all, items: params[:per_page])
        end

        def show; end

        def create
          @communication = Communication.create!(communication_params)
          if params[:image]
            @communication.image.attach(data: params[:image])
          end
          render :show
        end

        def update
          raise ActionController::BadRequest, 'can not update a published communication' if @communication.published
          @communication.update!(communication_params)
          if params[:image]
            @communication.image.attach(data: params[:image])
          end
          render :show
        end

        def destroy
          @communication.destroy
        end

        def set_communication
          @communication = Communication.find(params[:id])
        end

        def communication_params
          params.require(:communication).permit(:title, :text, :published, :recurrent_on)
        end
      end
    end
  end
end
