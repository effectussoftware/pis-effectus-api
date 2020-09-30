# frozen_string_literal: true

class GoogleValidationTokenService
  def self.validate_token(token)
    validator = GoogleIDToken::Validator.new
    begin
        @payload = validator.check(token, ENV['GOOGLE_CLIENT_ID'])
    rescue GoogleIDToken::ValidationError => _
      false
    end
  end
end
