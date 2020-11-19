# frozen_string_literal: true

module Api
  module V1
    module Admin
      class EventsController < Api::V1::Admin::AdminApiController
        def index
          @events = Event.all
          @events = sort_events if params[:sort]
          @pagy, @events = pagy(@events, items: params[:per_page])
        end

        def create
          @event = Event.create!(event_params)
        end

        def show
          @event = Event.find(params[:id])
        end

        def update
          @event = Event.find(params[:id])
          @event.update!(event_params)
        end

        private

        def sort_events
          sort = Oj.load(params[:sort])
          order_sort = sort.join(' ')
          @events.order(order_sort)
        end

        def event_params # rubocop:disable Metrics/MethodLength
          params.require(:event).permit(
            :name,
            :description,
            :address,
            :start_time,
            :end_time,
            :cost,
            :cancelled,
            :published,
            invitations_attributes: %i[user_id confirmation attend]
          )
        end
      end
    end
  end
end
