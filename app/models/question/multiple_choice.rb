# frozen_string_literal: true

class Question::MultipleChoice < Question
  validates :options, presence: true

  validate :more_than_one_option

  def more_than_one_option
    return unless options.length < 2

    errors.add(:base, :not_enough_options)
  end
end
