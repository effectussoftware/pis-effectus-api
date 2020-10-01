# frozen_string_literal: true

module Api
  module V1
    module Admin
      class AuthenticationAdminController < Api::V1::ApiController

        def login
          if user_from_google = GoogleValidationTokenService.validate_token(params[:token])
            # update token, generate updated auth headers for response
            if @user = User.find_by(email: user_from_google['email'], is_admin: true)
              new_auth_header = @user.create_new_auth_token
              # update response with the header that will be required by the next request
              response.headers.merge!(new_auth_header)
              response.headers.merge!({ 'uid' => @user.uid })
            else
              raise ::UnauthorizedException
            end
          end
        end
      end
    end
  end
end
