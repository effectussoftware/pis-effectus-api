# frozen_string_literal: true

class Communication < ApplicationRecord
  validates :title, presence: true

  def init
    self.published = false if published.nil?
  end
end
