# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validate :numerical_answer
  validate :range_answer

  def numerical_answer
    return unless question.type == 'Question::Numeric'
    return if begin
                Integer(value)
              rescue StandardError
                nil
              end

    errors.add(:base, :invalid_numeric_value)
  end

  def range_answer
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
