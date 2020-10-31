# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Communication, type: :model do
  describe 'validations' do
    it 'validate presence of required fields' do
      should validate_presence_of(:title)
    end

    it "can't be updated once published" do
      com = create(:communication, published: true)
      expect(com.update(title: 'new title')).to eq(false)
      expect(com.errors[:published]).to include("can't update communications once published")
      expect(com.update(published: false)).to eq(false)
    end

    it 'can be updated if not published' do
      com = create(:communication, recurrent_on: Time.zone.now, published: false)
      expect(com.update(title: 'new title')).to eq(true)
      expect(com.title).to eq('new title')
    end
  end

  describe 'after saves' do
    it 'sends notification if created published' do
      Timecop.freeze(Time.zone.local(2020))
      create_list(:user, 15)
      create(:communication)
      allow(User).to receive(:send_notification).and_return(true)
      com = build(:communication, published: true)
      expect(User).to receive(:send_notification)
        .with(com.title,
              com.text,
              { id: Communication.last.id + 1, updated_at: Time.zone.now, type: com.class.to_s })
      expect(com.save).to eq(true)
      Timecop.return
    end

    it 'sends notification if updated to published' do
      Timecop.freeze(Time.zone.local(2020))
      create_list(:user, 15)
      com = create(:communication, published: false)
      allow(User).to receive(:send_notification).and_return(true)
      expect(User).to receive(:send_notification)
        .with(com.title,
              com.text,
              { id: com.id, updated_at: com.updated_at, type: com.class.to_s })
      expect(com.update(published: true)).to eq(true)
      Timecop.return
    end
  end
end
