require 'rails_helper'

RSpec.describe Poll, type: :model do
  describe 'validations' do
    it 'validate presence of required fields' do
      should validate_presence_of(:name)
      should have_many(:questions)
    end
  end

  describe 'end_time must be greater than start_time' do
    it 'validate the value of end_time and start_time' do
      expect do
        create(:poll,name: "Encuesta1",  start_time: Time.zone.now + 2.hour, end_time: Time.zone.now + 1.hour)
      end.to raise_error(ActiveRecord::RecordInvalid,
                         'Validation failed: Start time La fecha de fin debe ser más grande que la fecha de inicio')
    end
  end
end

