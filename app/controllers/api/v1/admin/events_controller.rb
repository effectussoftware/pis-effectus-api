# frozen_string_literal: true

module Api
  module V1
    module Admin
      class EventsController < Api::V1::Admin::AdminApiController
        def index
          @events = Event.all
        end

        def create
          ActiveRecord::Base.transaction do
            @event = Event.create!(create_params)

            UserEvent.create!(create_user_event)
          end
        end

        def show
          @event = Event.find(params[:id])
        end

        def update
          @event = Event.find(params[:id])
          @event.update!(create_params)
        end

        private

        def create_params
          params.require(:event).permit(:name, :address, :date, :start_time, :cost, :duration)
        end

        def update_params
          params.require(:event).permite(:name, :address, :date, :start_time, :cost, :duration)
        end

        def create_user_event
          event_user = []
          raise StandardError, 'users are required' unless params[:users]&.size&.positive?

          params[:users].each do |user|
            event_user.push({
                              user_id: user[:id],
                              event_id: @event.id
                            })
          end
          event_user
        end
      end
    end
  end
end
