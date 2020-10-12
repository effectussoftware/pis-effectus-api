# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :invitations, dependent: :delete_all
  has_many :users, through: :invitations
  validates :name, presence: true
  validates :cost, presence: true
end
