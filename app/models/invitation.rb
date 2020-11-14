# frozen_string_literal: true

class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :event
  after_create :send_notification

  def new_updates_since_last_seen?
    changed_last_seen.present? && event.updated_event_at > changed_last_seen
  end

  private

  def send_notification
    user.send_notification(
      event.name,
      'Tienes una nueva invitación a un evento.',
      { id: id, updated_at: updated_at, event: event.id, start_time: event.start_time, type: self.class.to_s }
    )
  end
end
