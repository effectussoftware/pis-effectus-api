# frozen_string_literal: true

class UnauthorizedException < StandardError
  def initialize(msg = 'No autorizado')
    super(msg)
  end
end
