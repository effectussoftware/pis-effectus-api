# frozen_string_literal: true

module Api
  module V1
    module Admin
      class AuthenticationAdminController < Api::V1::ApiController
        def login
          # Rises UnauthorizedException if token isn't valid
          user_from_google = GoogleValidationTokenService.validate_token(params[:token])

          # Rise exception if user doesn't exist or if it isn't admin
          raise ::UnauthorizedException unless (@user = User.find_by(email: user_from_google['email'], is_admin: true , is_active: true))

          new_auth_header = @user.create_new_auth_token
          # update response with the header that will be required by the next request
          response.headers.merge!(new_auth_header)
          response.headers.merge!({ 'uid' => @user.uid })
        end
      end
    end
  end
end
