# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren:

class Question::MultiSelect < Question
  validates :options, presence: true

  validate :more_than_one_option

  def more_than_one_option
    return unless options.length < 2

    errors.add(:base, :not_enough_options)
  end

  # rubocop:enable Style/ClassAndModuleChildren:
end
