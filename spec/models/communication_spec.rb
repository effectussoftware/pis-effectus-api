# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Communication, type: :model do
  describe 'validations' do
    it 'validate presence of required fields' do
      should validate_presence_of(:title)
    end
  end
end
