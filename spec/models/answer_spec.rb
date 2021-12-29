# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'validations' do
    it 'validate presence of required fields' do
      should belong_to(:user)
      should belong_to(:question)
      should validate_presence_of(:value)
    end
  end

  it 'answer value must be in questions range' do
    ques = create(:question, type: 'Question::Range')
    expect do
      create(:answer, question_id: ques.id, value: rand(11..100))
    end.to raise_error(ActiveRecord::RecordInvalid,
                       'Validation failed: translation missing: ' \
                        'en.activerecord.errors.models.answer.attributes.base.invalid_range_value')
  end
end
