# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it 'validate presence of required fields' do
      should validate_presence_of(:name)
      should validate_presence_of(:cost)
      should have_many(:users).through(:invitations)
    end
  end
end
