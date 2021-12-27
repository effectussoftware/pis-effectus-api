# frozen_string_literal: true
# rubocop:disable all
class Question::Range < Question
  validates :max_range, numericality: { greater_than_or_equal_to: 0 }, allow_nil: false
  validates :min_range, numericality: { greater_than_or_equal_to: 0,
                                        less_than_or_equal_to: :max_range }, allow_nil: false

end
