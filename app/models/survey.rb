# frozen_string_literal: true

class Survey < ApplicationRecord
  has_many :questions
  validates :name, presence: true
end
