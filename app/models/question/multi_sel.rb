# frozen_string_literal: true
class Question::MultiSel < Question
  validates :options, presence: true
end