# frozen_string_literal: true

module Api
  module V1
    class DeviceRegistrationsController < Api::V1::ApiController
      def create
        if params[:device].try(:[], :token).nil?
          raise ActionController::BadRequest.new, 'Debe mandar el token del dispositivo'
        end

        save_push_notification_token
        head :ok
      end

      private

      def save_push_notification_token
        current_user.tokens[request.headers[:client]].merge!(push_notification_token: params[:device][:token])
        current_user.save!
      end
    end
  end
end
