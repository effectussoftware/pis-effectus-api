# frozen_string_literal: true

class Invite < ApplicationRecord
  belongs_to :user
  belongs_to :event
end
