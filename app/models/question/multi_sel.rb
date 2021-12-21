# frozen_string_literal: true
# rubocop:disable all
class Question::MultiSel < Question
  validates :options, presence: true
end
