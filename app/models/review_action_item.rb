# frozen_string_literal: true

class ReviewActionItem < ApplicationRecord
  belongs_to :review

  validates :commitment_owner, acceptance: { accept: %w[user effectus] }
end
