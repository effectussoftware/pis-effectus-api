# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  validates :value, presence: true

  validate :numerical_answer
  validate :range_answer

  def numerical_answer
    return if question.nil?

    return unless question.type == 'Question::Numeric'
    return if value.is_a?(Integer)

    errors.add(:base, :invalid_numeric_value)
  end

  def range_answer
    return if question.nil?

    answer_value = begin
                     Integer(value)
                   rescue StandardError
                     nil
                   end
    return unless question.type == 'Question::Range'

    return unless answer_value.nil? || (question.max_range < answer_value || question.min_range > answer_value)

    errors.add(:base, :invalid_range_value)
  end
end
