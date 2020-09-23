
class AuthenticationController< ApplicationController

    def login
        payload = validate_token(params[:token])
        render json:{payload:payload}, status: :ok
    end
    

    def validate_token(token)
        validator = GoogleIDToken::Validator.new
        begin
            @payload = validator.check(token, ENV['GOOGLE_CLIENT_ID'])            
          rescue GoogleIDToken::ValidationError => e
            false
          end
        
    end
    
    
end