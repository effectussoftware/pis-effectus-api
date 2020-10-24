# frozen_string_literal: true

class ReviewActionItem < ApplicationRecord
  belongs_to :reviewer_review, class_name: 'Review', optional: true
  belongs_to :user_review, class_name: 'Review', optional: true

  validates :description, presence: true
  validates :commitment_owner, acceptance: { accept: %w[user effectus] }

  def review
    reviewer_review || user_review
  end

end
