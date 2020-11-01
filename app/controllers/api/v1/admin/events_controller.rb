# frozen_string_literal: true

module Api
  module V1
    module Admin
      class EventsController < Api::V1::Admin::AdminApiController
        def index
          @pagy, @events = pagy(Event.all.order('updated_at DESC'), items: params[:per_page])
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
          @event.updated_event_at = Time.zone.now
        end

        private

        def event_params
          params.require(:event).permit(
            :name,
            :address,
            :start_time,
            :end_time,
            :cost,
            :cancelled,
            invitations_attributes: %i[id user_id confitmation attend]
          )
        end
      end
    end
  end
end
