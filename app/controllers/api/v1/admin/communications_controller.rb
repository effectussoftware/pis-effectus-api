# frozen_string_literal: true

module Api
  module V1
    module Admin
      class CommunicationsController < Api::V1::Admin::AdminApiController
        before_action :set_communication, only: %i[show update destroy]

        def index
          @communications = if params[:published]
                              Communication.where(published: params[:published])
                            else
                              Communication.all
                            end
          @communications = sort_communications if params[:sort]
          @pagy, @communications = pagy(@communications, items: params[:per_page])
        end

        def show; end

        def create
          @communication = Communication.create!(communication_params)
          handle_attachments
          render :show
        end

        def update
          @communication.update!(communication_params)
          handle_attachments
          render :show
        end

        def destroy
          @communication.destroy
        end

        def set_communication
          @communication = Communication.find(params[:id])
        end

        private

        def communication_params
          params.require(:communication).permit(:title, :text, :published, :recurrent_on)
        end

        def sort_communications
          sort = Oj.load(params[:sort])
          order_sort = if sort[1]
                         "#{sort[0]} #{sort[1]}"
                       else
                         sort[0]
                       end
          @communications.order(order_sort)
        end

        def handle_attachments
          @communication.image.attach(data: params[:communication][:image]) if params[:communication][:image]
        end
      end
    end
  end
end
