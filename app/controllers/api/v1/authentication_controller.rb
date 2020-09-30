# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < Api::V1::ApiController
      def login
        if user_from_google = GoogleValidationTokenService.validate_token(params[:token])
          # update token, generate updated auth headers for response
          user = User.where(email: user_from_google['email'])
                     .first_or_create!(create_params(user_from_google))
          new_auth_header = user.create_new_auth_token
          # update response with the header that will be required by the next request
          response.headers.merge!(new_auth_header)
          response.headers.merge!({ 'uid' => user.uid })
          render json: user, status: :ok
        else
          raise ::UnauthorizedException, 'Invalid Google Token'
        end
      end

      private

      def create_params(user)
        {
          name: user['name'],
          email: user['email'],
          picture: user['picture']
        }
      end
    end
  end
end
