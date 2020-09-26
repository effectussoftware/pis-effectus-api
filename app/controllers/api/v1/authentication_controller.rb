class Api::V1::AuthenticationController < ApplicationController

    def login
      user_from_google = GoogleValidationTokenService.validate_token(params[:token])
        if user_from_google
          # update token, generate updated auth headers for response
          user = User.where(email: user_from_google["email"])
            .first_or_initialize(create_params(user_from_google))
          new_auth_header = user.create_new_auth_token()
          # update response with the header that will be required by the next request
          response.headers.merge!(new_auth_header)
          render json: user, status: :ok        
      else
        render json:{error: 'Invalid Token'} , status: :unauthorized
      end
    end

    private
    def create_params(user)
      hash_user = {
        name: user['name'],
        email: user['email'],
        picture: user['picture']
      }
    end

end
