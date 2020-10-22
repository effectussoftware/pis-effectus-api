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
    end
  end

  describe 'after updates' do
    it 'sends notification once published' do
      Timecop.freeze
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
