# frozen_string_literal: true

module Api
  module V1
    module Admin
      class AdminApiController < Api::V1::ApiController
        skip_before_action :authenticate_api_v1_user!
        before_action :authenticate_admin!

        alias current_admin current_api_v1_user

        def authenticate_admin!
          if current_admin && current_admin['is_active'] &&
             current_admin['is_admin']
            true
          else
            raise ::UnauthorizedException
          end
        end
      end
    end
  end
end
