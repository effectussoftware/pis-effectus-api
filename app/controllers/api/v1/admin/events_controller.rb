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
            @event = Event.create!(event_params)
            Invite.create!(create_invite)
          end
        end

        def show
          @event = Event.find(params[:id])
        end

        def update
          @event = Event.find(params[:id])
          @event.update!(event_params)
        end

        private

        def event_params
          params.require(:event).permit(:name, :address, :date, :start_time, :cost, :duration)
        end

        def create_invite
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
