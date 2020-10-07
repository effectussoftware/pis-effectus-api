# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :user_event, dependent: :delete_all
  validates :name, presence: true
  validates :cost, presence: true, numericality: { greater_than: 0 }
end
