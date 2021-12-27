# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'validations' do
    it 'validate presence of required fields' do
      should validate_presence_of(:type)
    end
  end

  describe 'max_range must be greater than min_range' do
    it 'validate the value of max_range and min_range' do
      expect do
        create(:question, max_range: rand(1..5), min_range: rand(6..10), type: "Question::Range")
      end.to raise_error(ActiveRecord::RecordInvalid,
                         'Validation failed: Max range El rango maximo debe ser más grande que el rango minimo')
    end
  end
end
