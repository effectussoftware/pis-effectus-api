# frozen_string_literal: true

class UnauthorizedException < StandardError
  def initialize(msg = 'Unathorized')
    super(msg)
  end
end
