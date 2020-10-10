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
            @event.user_ids = params[:user_ids]
          end
        end

        def show
          @event = Event.find(params[:id])
        end

        def update
          @event = Event.find(params[:id])
          users_invited = @event.user_ids
          @event.update!(event_params)
          users_to_add = params[:user_ids] - users_invited
          raise StandardError, "you can't remove a invited person" unless (users_invited - params[:user_ids]).empty?
          @event.user_ids = users_invited + users_to_add unless users_to_add.empty?
        end

        private

        def event_params
          params.require(:event).permit(:name, :address, :start_time, :end_time, :cost)
        end
      end
    end
  end
end
