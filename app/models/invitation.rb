# frozen_string_literal: true

class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :event
end
