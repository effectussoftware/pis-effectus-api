# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :invitations, dependent: :delete_all
  has_many :users, through: :invitations
  validates :name, presence: true
  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
