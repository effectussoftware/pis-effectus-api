# frozen_string_literal: true

class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :event
  after_create :send_new_event_notification

  scope :not_confirmed, -> { where(confirmation: false) }
  scope :confirmed, -> { where(confirmation: true) }

  def new_updates_since_last_seen?
    changed_last_seen.present? && event.updated_event_at > changed_last_seen
  end

  def send_48_hour_reminder
    send_notification('Please confirm your attendance to the event.')
  end

  private

  def send_new_event_notification
    send_notification('You are invited to an event.')
  end

  def send_notification(message)
    user.send_notification(
      event.name,
      message,
      { id: id, updated_event_at: event.updated_event_at, event: event.id, start_time: event.start_time,
        type: self.class.to_s }
    )
  end
end
