# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'validations' do
    it 'validate presence of required fields' do
      should validate_presence_of(:title)
    end
    it "can't crate a review with a user reviewer" do
      user = create(:user)
      expect { create(:review, reviewer: user) }
        .to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Reviewer the reviewer must be an admin')
    end
  end

  describe 'after creates' do
    it 'sends notification' do
      Timecop.freeze(Time.zone.local(2020))
      user_review = create(:user)
      allow(user_review).to receive(:send_notification).and_return(true)
      create(:review)
      rev = build(:review, user: user_review)
      expect(user_review).to receive(:send_notification)
        .with(rev.title,
              'You have a new review available.',
              { id: Review.last.id + 1, updated_at: Time.zone.now, type: rev.class.to_s })
      expect(rev.save).to eq(true)
      Timecop.return
    end
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:reviewer) }
  end
end
