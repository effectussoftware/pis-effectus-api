# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe 'validations' do
    it 'validate presence of required fields' do
      should belong_to(:user)
      should belong_to(:event)
    end
  end
end
