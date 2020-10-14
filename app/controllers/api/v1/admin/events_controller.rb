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
            raise StandardError, 'user_ids are required' unless params[:user_ids] && !params[:user_ids].empty?

            @event.user_ids = params[:user_ids]
          end
        end

        def show
          @event = Event.find(params[:id])
        end

        def update
          @event = Event.find(params[:id])
          users_invited = @event.user_ids
          @event.user_ids = calculate_list_of_users(users_invited)
          @event.update!(event_params)
          @event.updated_event_at = Time.now
        end

        private

        def calculate_list_of_users(users_invited)
          users_to_add = params[:user_ids] - users_invited
          raise StandardError, "you can't remove a invited person" unless (users_invited - params[:user_ids]).empty?

          users = users_invited + users_to_add unless users_to_add.empty?
          users
        end

        def event_params
          params.require(:event).permit(:name, :address, :start_time, :end_time, :cost, :cancelled)
        end
      end
    end
  end
end
