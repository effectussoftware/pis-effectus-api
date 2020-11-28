# frozen_string_literal: true

class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :event
  after_create :send_new_event_notification, if: :event_is_published

  before_create :abort_if_event_is_cancelled
  before_destroy :abort_if_event_is_published

  scope :not_confirmed, -> { where(confirmation: false) }
  scope :confirmed, -> { where(confirmation: true) }

  def new_updates_since_last_seen?
    changed_last_seen.present? && event.updated_event_at > changed_last_seen
  end

  def send_update_notification
    message = event.cancelled ? 'Un evento ha sido cancelado.' : 'Un evento ha sido modificado.'
    send_notification(message)
  end

  def send_48_hour_reminder
    send_notification('Confirma tu asistencia al evento.')
  end

  def send_new_event_notification
    return if notification_sent

    send_notification('Tienes una nueva invitación a un evento.')
    update(notification_sent: true)
  end

  private

  def abort_if_event_is_cancelled
    return unless event.cancelled

    errors.add(:event_id, 'No es posible crear una invitacion de un evento cancelado')
    throw :abort, 'No es posible crear una invitacion de un evento cancelado'
  end

  def abort_if_event_is_published
    return unless event.published

    errors.add(:event_id, 'No es posible eliminar una invitacion de un evento publicado')
    throw :abort, 'No es posible eliminar una invitacion de un evento publicado'
  end

  def event_is_published
    event.published
  end

  def send_notification(message)
    return unless user.is_active

    user.send_notification(
      event.name,
      message,
      { id: id, updated_at: event.updated_event_at, event: event.id, start_time: event.start_time,
        type: self.class.to_s }
    )
  end
end
