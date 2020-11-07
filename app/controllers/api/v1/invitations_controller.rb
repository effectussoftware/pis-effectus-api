# frozen_string_literal: true

module Api
  module V1
    class InvitationsController < Api::V1::ApiController
      def update
        @invitation = Invitation.find_by!(event_id: params[:id], user_id: current_api_v1_user.id)
        raise ActiveRecord::RecordNotFound, 'invitation not found' unless @invitation

        @invitation.update!(update_params)
      end

      private

      def update_params
        params.require(:invitation).permit(:attend, :confirmation)
      end
    end
  end
end
