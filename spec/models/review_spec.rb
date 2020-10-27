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
  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:reviewer) }
  end
end
