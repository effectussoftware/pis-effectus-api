
class AuthenticationController< ApplicationController
  before_action :authenticate_user!,only: [:authenticate_test]
    def login
      user_to_create = GoogleValidationTokenService.validate_token(params[:id_token])
        if user_to_create
          # update token, generate updated auth headers for response
          generate_random_password(user_to_create)
          user = User.where(email: payload["email"])
            .first_or_initialize(create_params(user_to_create))
          new_auth_header = user.create_new_auth_token()
          # update response with the header that will be required by the next request
          response.headers.merge!(new_auth_header)
          render json: user, status: :ok        
        else
          render json:{error: 'Invalid Token'} , status: :unauthorized
        end
    end

    def authenticate_test
      user = User.first()
      render json:{stuatus: 'ok'} , status: :ok
    end
    
    private
    def create_params(user)
      hash_user = {
        name: user['name'],
        email: user['email'],
        picture: user['picture'],
        password: user['password'],
        password_confirmation: user['password_confirmation'],
        is_active: true,
        is_admin: false
      }
    end


    def generate_random_password(user)
      password = SecureRandom.urlsafe_base64(nil, false)
      user['password'] = password
      user['password_confirmation'] = password
    end
end
