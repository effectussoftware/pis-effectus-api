# frozen_string_literal: true

module Api
  module V1
    module Admin
      class EventsController < Api::V1::Admin::AdminApiController
        def index
          @users = User.all
        end

        def show
          @user = User.find(params[:id])
        end

        def update
          @user = User.find(params[:id])
          @user.update!(update_params)
        end

        private

        def update_params
          params.require(:user).permit(:is_admin, :is_active)
        end
      end
    end
  end
end
