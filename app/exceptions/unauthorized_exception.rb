# frozen_string_literal: true

class UnauthorizedException < StandardError
  def initialize(msg = 'Unauthorized')
    super(msg)
  end
end
