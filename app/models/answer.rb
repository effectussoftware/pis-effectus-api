# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :value, presence: true

  validate :numerical_answer
  validate :range_answer
  validate :options_answer
  validate :duplicate_answer

  def numerical_answer
    return if question.nil?

    return unless question.type == 'Question::Numeric'
    return if begin
      Integer(value)
              rescue StandardError
                nil
    end

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

  def options_answer
    return if question.nil?

    return unless question.type == 'Question::MultipleChoice' || question.type == 'Question::MultiSelect'

    return if valid_option

    errors.add(:base, :invalid_option_value)
  end

  private

  def valid_option
    multiple_choice_answer = MultipleChoiceAnswer.all.by_question(question.id)
    multiple_choice_answer.each do |option|
      return true if value == option.value
    end
    false
  end

  def duplicate_answer
    return if question.nil?

    answer = if question.type == 'Question::MultiSelect'
               Answer.find_by(user_id: user_id, question_id: question_id, value: value)
             else
               Answer.find_by(user_id: user_id, question_id: question_id)
             end
    errors.add(:base, I18n.t('errors.duplicated_answer')) if answer.present?
  end
end
