# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :invites, dependent: :delete_all
  has_many :users, through: :invites
  validates :name, presence: true
  validates :cost, presence: true
end
