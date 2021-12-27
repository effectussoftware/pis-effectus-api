# frozen_string_literal: true

class Question < ApplicationRecord
  has_many    :answers, class_name: '::Answer', dependent: :destroy
  has_many    :multiple_choice_answers, class_name: '::MultipleChoiceAnswer', dependent: :destroy
  belongs_to  :survey,  class_name: '::Survey'
  validates :name, presence: true
  validates :type, presence: true

  validate :max_range_must_be_greater_than_min_range

  def max_range_must_be_greater_than_min_range
    return unless type == "Question::Range"
    
    return unless check_max_range_and_min_range

    errors.add(:max_range, 'El rango maximo debe ser más grande que el rango minimo')
  end

  def check_max_range_and_min_range
    (!max_range || !min_range) || (max_range <= min_range)
  end
end
