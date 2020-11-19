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
