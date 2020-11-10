# frozen_string_literal: true

class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :event

  def new_updates_since_last_seen?
    changed_last_seen.present? && event.updated_event_at > changed_last_seen
  end
end
