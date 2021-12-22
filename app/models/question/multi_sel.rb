# frozen_string_literal: true
# rubocop:disable all
class Question::MultiSelect < Question
  validates :options, presence: true
end
