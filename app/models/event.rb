# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :user_event
end
