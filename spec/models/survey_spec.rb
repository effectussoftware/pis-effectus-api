# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Survey, type: :model do
  describe 'validations' do
    it 'validate presence of required fields' do
      should validate_presence_of(:name)
    end
  end
end
