# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it 'validate presence of required fields' do
      should validate_presence_of(:name)
      should validate_presence_of(:cost)
      should validate_presence_of(:start_time)
      should validate_presence_of(:end_time)
      should have_many(:users).through(:invitations)
    end
  end
  describe 'invitations must be required' do
    it 'validate presence of invitations' do
      expect do
        Event.create!(
          name: 'test',
          cost: 200,
          start_time: Time.now + 2.hour,
          end_time: Time.now + 3.hour
        )
      end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Invitations the invitations cannot be empty')
    end
  end

  describe 'end_time must be greater than start_time' do
    it 'validate the value of end_time and start_time' do
      expect do
        create(:event, start_time: Time.zone.now + 2.hour, end_time: Time.zone.now + 1.hour)
      end.to raise_error(ActiveRecord::RecordInvalid,
                         'Validation failed: Start time end_time must be greater than start_time')
    end
  end

  describe 'end_time and start_time must be greater than now' do
    it 'validate the value of end_time and start_time' do
      expect do
        create(:event, start_time: Time.zone.now, end_time: Time.zone.now + 1.hour)
      end.to raise_error(ActiveRecord::RecordInvalid,
                         'Validation failed: Start time end_time and start_time must be greater than now')
    end
  end
end
