class AuthenticationController< ApplicationController
  before_action :authenticate_user!,only: [:authenticate_test]
    def login
      user_from_google = GoogleValidationTokenService.validate_token(params[:token])
        if user_from_google
          # update token, generate updated auth headers for response
          generate_random_password(user_from_google)
          user = User.where(email: user_from_google["email"])
            .first_or_initialize(create_params(user_from_google))
          new_auth_header = user.create_new_auth_token()
          # update response with the header that will be required by the next request
          response.headers.merge!(new_auth_header)
          response.headers.merge!({'uid' => user.uid})
          render json: user, status: :ok
      else
        render json:{error: 'Invalid Token'} , status: :unauthorized
      end
    end

    def authenticate_test
      render json:{stuatus: 'ok'} , status: :ok
    end

    private
    def create_params(user)
      hash_user = {
        name: user['name'],
        email: user['email'],
        picture: user['picture'],
        password: user['password'],
        password_confirmation: user['password_confirmation']
      }
    end

    def generate_random_password(user)
      password = SecureRandom.urlsafe_base64(nil, false)
      user['password'] = password
      user['password_confirmation'] = password
    end
end
