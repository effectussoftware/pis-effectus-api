# frozen_string_literal: true

class Communication < ApplicationRecord
  validates :title, presence: true
end
