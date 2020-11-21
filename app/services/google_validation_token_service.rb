# frozen_string_literal: true

class GoogleValidationTokenService
  def self.validate_token(token)
    validator = GoogleIDToken::Validator.new
    begin
      @payload = validator.check(token, ENV['GOOGLE_CLIENT_ID'])
    rescue GoogleIDToken::ValidationError => _e
      raise ::UnauthorizedException, 'El token de Google es inválido'
    end
  end
end
