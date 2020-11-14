# frozen_string_literal: true

class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :event
  after_create :send_new_event_notification

  def new_updates_since_last_seen?
    changed_last_seen.present? && event.updated_event_at > changed_last_seen
  end

  def send_update_notification
    send_notification('Un evento ha sido modificado.')
  end

  private

  def send_new_event_notification
    send_notification('Tienes una nueva invitación a un evento.')
  end

  def send_notification(message)
    user.send_notification(
      event.name,
      message,
      { id: id, updated_at: event.updated_event_at, event: event.id, start_time: event.start_time,
        type: self.class.to_s }
    )
  end
end
