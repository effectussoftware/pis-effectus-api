# frozen_string_literal: true
# rubocop:disable all
class Question::MultipleChoice < Question
  validates :options, presence: true
end
