# frozen_string_literal: true

module Api
  module V1
    class DeviceRegistrationsController < Api::V1::ApiController
      def create
        current_user.push_notification_tokens << params[:device][:token]
        head :ok
      end
    end
  end
end
