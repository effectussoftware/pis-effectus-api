# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReviewActionItem, type: :model do
  describe 'validations' do
    it 'validates presence of required fields' do
      should validate_presence_of(:description)
      should validate_presence_of(:completed)
    end
  end
end
