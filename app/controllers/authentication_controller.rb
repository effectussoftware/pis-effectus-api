require 'byebug'
class AuthenticationController< ApplicationController

    def login
        payload = GoogleValidationTokenService.validate_token(params[:token])
        if payload
          # update token, generate updated auth headers for response
          user_to_create = payload
          generate_random_password(user_to_create)
          
          user=User.create(email: user_to_create["email"],password: user_to_create[:password],password_confirmation: user_to_create[:password_confirmation])

          new_auth_header = user.create_new_auth_token()
          # update response with the header that will be required by the next request
          response.headers.merge!(new_auth_header)
          render json:{payload:payload}, status: :ok        
      else
        render json:{error: 'Invalid Token'} , status: :unauthorized
      end
    end
    

    private 
    def generate_random_password(user)
      password = SecureRandom.urlsafe_base64(nil, false)
      user[:password] =password
      user[:password_confirmation]=password
    end
    
    
    
end