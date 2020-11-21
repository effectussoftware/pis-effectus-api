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
      end.to raise_error(ActiveRecord::RecordInvalid,
                         'Validation failed: Invitations Debe haber al menos una invitación')
    end
  end

  describe 'end_time must be greater than start_time' do
    it 'validate the value of end_time and start_time' do
      expect do
        create(:event, start_time: Time.zone.now + 2.hour, end_time: Time.zone.now + 1.hour)
      end.to raise_error(ActiveRecord::RecordInvalid,
                         'Validation failed: Start time La fecha de fin debe ser más grande que la fecha de inicio')
    end
  end

  describe 'end_time and start_time must be greater than now' do
    it 'validate the value of end_time and start_time' do
      expect do
        create(:event, start_time: Time.zone.now, end_time: Time.zone.now + 1.hour)
      end.to raise_error(ActiveRecord::RecordInvalid,
                         'Validation failed: Start time Las fechas de fin e inicio deben estar en el futuro')
    end
  end

  describe 'updates the privates fields without check the start_time and end_time validations' do
    it 'updates the event cost with start_time < Time.zone.now' do
      event = nil
      Timecop.freeze(Date.today - 1.hour) do
        event = create(:event, cost: 100, start_time: Time.zone.now, end_time: Time.zone.now + 2.hour)
      end
      Timecop.freeze(Date.today) do
        expect { event.update(cost: 200) }.to change(event, :cost).to 200
      end
    end
  end

  describe '.set_updated_event_at' do
    it 'updates updated_event_at when public fields are changed' do
      event = nil
      Timecop.freeze(Date.today - 1.hour) do
        event = create(:event, start_time: Time.zone.now + 1.hour, end_time: Time.zone.now + 2.hour)
      end
      Timecop.freeze(Date.today) do
        expect { event.update(end_time: Time.zone.now + 3.hour) }.to change(event, :updated_event_at).to Time.zone.now
      end
    end

    it 'does not update updated_event_at when only private fields are changed' do
      event = nil
      Timecop.freeze(Date.today - 1.hour) do
        event = create(:event, cost: 800, start_time: Time.zone.now + 1.hour, end_time: Time.zone.now + 2.hour)
      end
      Timecop.freeze(Date.today) do
        expect { event.update(cost: 100) }.to_not change(event, :updated_event_at)
      end
    end
  end

  describe 'after an event is modified' do
    it 'sends notification if public fields are updated and the event is published' do
      Timecop.freeze(Time.zone.local(2020))
      ev = create(:event, published: true)
      user = create(:user)
      expect(user).to_not receive(:send_notification)

      new_name = 'Nuevo titulo'
      message = ev.cancelled ? 'Un evento ha sido cancelado.' : 'Un evento ha sido modificado.'
      ev.invitations.each do |invitation|
        allow(invitation.user).to receive(:send_notification).and_return(true)
        expect(invitation.user).to receive(:send_notification)
          .with(new_name,
                message,
                { id: invitation.id, updated_at: ev.updated_event_at, event: ev.id, start_time: ev.start_time,
                  type: Invitation.to_s })
      end
      expect(ev.update(name: new_name)).to eq(true)
      Timecop.return
    end

    it 'must not send notification with a event not published' do
      Timecop.freeze(Time.zone.local(2020))
      ev = create(:event, published: false)
      user = User.find(ev.invitations.first.user_id)
      new_name = 'Nuevo titulo Editado'
      expect(user).to_not receive(:send_notification)
      expect(ev.update(name: new_name)).to eq true
    end
  end
end
