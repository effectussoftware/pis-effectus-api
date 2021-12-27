# frozen_string_literal: true
# rubocop:disable all
class Question::Range < Question
  validates :max_range, numericality: { greater_than_or_equal_to: 0 }, allow_nil: false
  validates :min_range, numericality: { greater_than_or_equal_to: 0,
                                        less_than_or_equal_to: :max_range }, allow_nil: false

  validate :max_range_must_be_greater_than_min_range

  def max_range_must_be_greater_than_min_range
    return unless check_max_range_and_min_range

    errors.add(:max_range, 'El rango maximo debe ser más grande que el rango minimo')
  end

  def check_max_range_and_min_range
    (!max_range || !min_range) || (max_range <= min_range)
  end
end
