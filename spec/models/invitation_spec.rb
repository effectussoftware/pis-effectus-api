# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe 'validations' do
    it 'validate presence of required fields' do
      should belong_to(:user)
      should belong_to(:event)
    end
  end

  describe '.new_updates_since_last_seen?' do
    it "is false if user hasn't seen the invitation" do
      event = create(:event)
      invitation = event.invitations.last
      invitation.update(changed_last_seen: nil)
      expect(invitation.new_updates_since_last_seen?).to eq(false)
    end

    it "is false if there hasn't been any changes since last seen" do
      event = create(:event)
      invitation = event.invitations.last
      invitation.update(changed_last_seen: 1.hour.from_now)
      expect(invitation.new_updates_since_last_seen?).to eq(false)
    end

    it 'is true if there are new changes seen user last saw the invitation' do
      event = create(:event)
      invitation = event.invitations.last
      invitation.update(changed_last_seen: 1.hour.ago)
      expect(invitation.new_updates_since_last_seen?).to eq(true)
    end
  end

  describe 'remove event invitations' do
    it 'destroy one invitation' do
      event = create(:event, published: false)
      invitation = create(:invitation, event: event)
      expect { invitation.destroy }.to change { event.invitations.count }.by(-1)
      expect(invitation.destroyed?).to eq(true)
    end

    it 'does not destroy one invitation' do
      event = create(:event, published: true)
      invitation = create(:invitation, event: event)
      expect { invitation.destroy }.to_not change { event.invitations.count }
      expect(invitation.destroyed?).to eq(false)
    end
  end

  describe 'add invitations to cancelled event' do
    it 'does not create a new invitation' do
      event = create(:event)
      event.update(cancelled: true)
      user = create(:user)
      invitation = Invitation.create(user_id: user.id, event_id: event.id)
      error_message = 'No es posible crear una invitacion de un evento cancelado'
      expect(invitation.id).to eq(nil)
      expect(invitation.errors.first).to eq([:event_id, error_message])
    end
  end

  describe 'send notifications' do
    it 'sends notification when created' do
      Timecop.freeze(Time.zone.local(2020))
      allow_any_instance_of(User).to receive(:send_notification).and_return(true)
      event = create(:event, published: true)
      user = create(:user, is_active: true)
      invitation = build(:invitation, event: event, user: user)
      expect(user).to receive(:send_notification)
        .with(event.name,
              'Tienes una nueva invitación a un evento.',
              {
                id: Invitation.last.id + 1,
                updated_at: Time.zone.now,
                event: event.id, start_time:
                event.start_time,
                type: invitation.class.to_s
              })
      expect(invitation.save).to eq(true)
      Timecop.return
    end
  end
end
