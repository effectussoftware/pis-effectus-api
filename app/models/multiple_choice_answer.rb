# frozen_string_literal: true

class MultipleChoiceAnswer < ApplicationRecord
  # Relations
  belongs_to :question, class_name: '::Question'
  # Validations
  validates :value, presence: true, uniqueness: { scope: :question_id }, length: { maximum: 19 }

  scope :by_question, ->(question_ids) { where(question_id: question_ids) }
end
